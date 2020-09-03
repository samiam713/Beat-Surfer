//
//  VirtualInstrument.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit
import Combine
// job is to play/pause notes on demand

class InstrumentSound {
    static var singleton: InstrumentSound! = nil
    static let timeShaved = 0.25
    
    static func loadSingleton() {
        if singleton == nil {
            singleton = InstrumentSound(origin: InstrumentAppearance.singleton.origin)
        }
    }
    
    var loadRequests = [String:AnyCancellable]()
    
    var blacks = [Int:AudioPlaybackController]()
    var whites = [AudioPlaybackController?].init(repeating: nil, count: 29)
    
    init(origin: Entity) {
        for note in 0...28 {
            if validBlack(index: note) {
                let blackName = "black\(note).aif"
                
                let blackCancellable = AudioFileResource.loadAsync(named: blackName, inputMode: .nonSpatial, shouldLoop: false).sink(receiveCompletion: {completion in
                    switch completion {
                    case .finished:
                        self.loadRequests[blackName] = nil
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }, receiveValue: {
                    self.blacks[note] = origin.prepareAudio($0)
                })
                loadRequests[blackName] = blackCancellable
//                let blackResource = try! AudioFileResource.load(named: blackName, inputMode: .nonSpatial, shouldLoop: false)
//                blacks[note] = origin.prepareAudio(blackResource)
            }
            
            let whiteName = "white\(note).aif"
            
            let whiteCancellable = AudioFileResource.loadAsync(named: whiteName, inputMode: .nonSpatial, shouldLoop: false).sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    self.loadRequests[whiteName] = nil
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: {
                self.whites[note] = origin.prepareAudio($0)
            })
            loadRequests[whiteName] = whiteCancellable
//            let whiteResource = try! AudioFileResource.load(named: whiteName, inputMode: .nonSpatial, shouldLoop: false)
//            whites.append(origin.prepareAudio(whiteResource))
        }
    }
    
    func startNote(index: Int, color: Note.NoteColor) {
        switch color {
        case .white:
            whites[index]?.play()
        case .black:
             blacks[index]?.play()
        }
    }

    // try pause then stop? this might get rid of click sound
    func stopNote(index: Int, color: Note.NoteColor) {
        switch color {
        case .white:
            whites[index]?.stop()
        case .black:
             blacks[index]?.stop()
        }
    }
}
