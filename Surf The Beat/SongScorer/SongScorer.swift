//
//  SongScorer.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

extension Song {
    func loadController() -> AudioPlaybackController {
        let resource = try! AudioFileResource.load(named: fileName)
        return InstrumentAppearance.singleton.origin.prepareAudio(resource)
    }
}

class SongScorer: ObservableObject { // initialized when a new song is loaded
    
    unowned let parent: ARView2
    
    let currentSong: Song
    let playbackController: AudioPlaybackController
    var currentSecond: Double = 0.0
    var currentScore = 0
    var eventHeap: MusicEventHeap! = nil
    
    var currentBlacks = [Int:Double]()
    var currentWhites = [Int:Double]()
    
    var inConsideration = Set<Note>()
    
    let noteVelocity: Double
    
    init(song: Song, parent: ARView2) {
        self.parent = parent
        
        self.currentSong = song
        self.playbackController = song.loadController()
        self.noteVelocity = 0.06/currentSong.timePerNote
        
        var events = [MusicEvent]()
        
        events.append(MusicEvent(time: 0.0, action: {[unowned self] in
            self.playbackController.play()
        }))
        events.append(MusicEvent(time: currentSong.songLength, action: {[unowned parent = parent] in
            parent.finishGame()
        }))
        
        for note in song.orderedNotes {
            switch note.type {
            case .continuous(time: let time):
                events.append(MusicEvent(time: currentSong.timePerNote*Double(note.startTime-7), action: {[unowned self] in
                    self.putIntoConsideration(note: note)
                }))
                events.append(MusicEvent(time: currentSong.timePerNote*Double(note.startTime+time), action: {[unowned self] in
                    self.takeOutOfConsideration(note: note)
                }))
            case .discrete:
                events.append(MusicEvent(time: currentSong.timePerNote*Double(note.startTime-7), action: {[unowned self] in
                    self.putIntoConsideration(note: note)
                }))
                events.append(MusicEvent(time: currentSong.timePerNote*Double(note.startTime+1), action: {[unowned self] in
                    self.takeOutOfConsideration(note: note)
                }))
            }
        }
        
        eventHeap = MusicEventHeap(originalEvents: events)
        currentSecond = eventHeap.top()!.time - 1.0
        
    }
    
    deinit {
        cancelAllPressed()
        for considered in inConsideration {
            takeOutOfConsideration(note: considered)
        }
    }
    
    func pause() {
        if currentSecond > 0.0 {playbackController.pause()}
        cancelAllPressed()
    }
    
    func play() {
        if currentSecond > 0.0 {playbackController.play()}
    }
    
    func putIntoConsideration(note: Note) {
        inConsideration.insert(note)
        InstrumentAppearance.singleton.addNote(note: note)
    }
    
    func takeOutOfConsideration(note: Note) { // notes are taken out of consideration either automatically or by being played
        inConsideration.remove(note)
        InstrumentAppearance.singleton.removeNote(note: note)
    }
    
    func update(newWhites: Set<Int>, oldWhites: Set<Int>, newBlacks: Set<Int>, oldBlacks: Set<Int>, timeInterval: Double, paused: Bool) {
        
        for key in currentBlacks.keys {
            currentBlacks[key]! += timeInterval
        }
        for key in currentWhites.keys {
            currentWhites[key]! += timeInterval
        }
        
        for newWhite in newWhites {
            startWhitePress(index: newWhite)
        }
        
        for newBlack in newBlacks {
            startBlackPress(index: newBlack)
        }
        
        for oldWhite in oldWhites {
            stopWhitePress(index: oldWhite, addScore: !paused)
        }
        
        for oldBlack in oldBlacks {
            stopBlackPress(index: oldBlack, addScore: !paused)
        }
        
        if !paused {
            
        currentSecond+=timeInterval

        while let nextEvent = eventHeap.top(), nextEvent.time < currentSecond {
            nextEvent.action()
            eventHeap.pop()
        }
        
        InstrumentAppearance.singleton.updateNotes(distance: Float(noteVelocity*timeInterval))
            
        }
    }
    
    static func propAInB(aLow: Double, aHigh: Double, bLow: Double, bHigh: Double) -> Double {
        if aLow > bHigh || aHigh < bLow {return .zero}
        
        let cappedLow = aLow > bLow ? aLow : bLow
        let cappedHigh = aHigh < bHigh ? aHigh : bHigh
        
        let aLength = aHigh-aLow
        let cappedLength = cappedHigh-cappedLow
        
        return cappedLength/aLength
    }
    
    func checkForMatch(index: Int, color: Note.NoteColor, start: Double, end: Double) {
        // find match in currently considered with a la proportionNotePressed * proportionOfPressOnNote
        let timeElapsed = end-start
        let discreteCenter: Double? = timeElapsed < currentSong.timePerNote/4.0 ? (start+end)/2.0 : nil
        
        // score for discretes is a piecewise "how close was "center of your tap" within "range of 0.5 seconds"
        
        var highestScore = 0.0
        var bestNote: Note? = nil
        
        for consideredNote in inConsideration {
            if consideredNote.noteNum != index || consideredNote.color != color {continue}
            switch consideredNote.type {
            case .continuous(time: let time):
                if discreteCenter != nil {continue}
                let noteStart = currentSong.timePerNote*Double(consideredNote.startTime)
                let noteEnd = currentSong.timePerNote*(Double(consideredNote.startTime + time) - InstrumentSound.timeShaved)
                
                let propPlayedInTheory = SongScorer.propAInB(aLow: start, aHigh: end, bLow: noteStart, bHigh: noteEnd)
                let propTheoryInPlayed = SongScorer.propAInB(aLow: noteStart, aHigh: noteEnd, bLow: start, bHigh: end)
                
                let score = propPlayedInTheory*propTheoryInPlayed

                if score > highestScore {
                    highestScore = score
                    bestNote = consideredNote
                } else {
                    continue
                }
                
            case .discrete:
                guard let discreteCenter = discreteCenter else {continue}
                let noteCenter = currentSong.timePerNote*(Double(consideredNote.startTime)+0.5)
                let distance = abs(noteCenter-discreteCenter)
                if distance < 0.5 {
                    let score = (0.5-distance)/0.5
                    if score > highestScore {
                        highestScore = score
                        bestNote = consideredNote
                    } else {
                        continue
                    }
                }
            }
            if let bestNote = bestNote {
                if highestScore <= 0.0 {fatalError()}
                let convertedScore = Int(highestScore*100)+1
                
                takeOutOfConsideration(note: bestNote)
                
                currentScore+=convertedScore
                parent.setRecentScore(to: convertedScore)
            }
        }
    }
    
    func startWhitePress(index: Int) {
        currentWhites[index] = 0.0
        InstrumentSound.singleton.startNote(index: index, color: .white)
        InstrumentAppearance.singleton.pressWhite(index: index)
    }
    
    func stopWhitePress(index: Int, addScore: Bool) {
        // see if we got any matches for press, if so remove and add score to tally
        if addScore {
            let endTime = currentSecond
            let startTime = endTime - currentWhites[index]!
            checkForMatch(index: index, color: .white, start: startTime, end: endTime)
        }
        
        InstrumentSound.singleton.stopNote(index: index, color: .white)
        InstrumentAppearance.singleton.unpressWhite(index: index)
        currentWhites[index] = nil
    }
    
    func startBlackPress(index: Int) {
        currentBlacks[index] = 0.0
        InstrumentSound.singleton.startNote(index: index, color: .black)
        InstrumentAppearance.singleton.pressBlack(index: index)
    }
    
    func stopBlackPress(index: Int, addScore: Bool) {
        if addScore {
            let endTime = currentSecond
            let startTime = endTime - currentBlacks[index]!
            checkForMatch(index: index, color: .black, start: startTime, end: endTime)
        }
        
        InstrumentSound.singleton.stopNote(index: index, color: .black)
        InstrumentAppearance.singleton.unpressBlack(index: index)
        currentBlacks[index] = nil
    }
    
    func cancelAllPressed() {
        
        for white in currentWhites.keys {
            stopWhitePress(index: white, addScore: false)
        }
        for black in currentBlacks.keys {
            stopBlackPress(index: black, addScore: false)
        }
    }
}
