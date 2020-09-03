//
//  ARView2.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/14/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import ARKit
import RealityKit
import Combine

class ARView2: ARView, ObservableObject {
    
    enum SheetType: Equatable {
        case loadSong
        case manual
        case victoryView
        case socialSharer
    }
    
    var currentRayCast: ARRaycastResult? = nil
    
    @Published var doneScanning = false
    
    @Published var paused = true
    @Published var placing = true
    
    @Published var settingsSheet = false
    @Published var resizing = false
    @Published var showSheet = false
    @Published var sheetType: SheetType = .loadSong
    var victoryData: (songName: String, image: UIImage, score: Int, gotHighScore: Bool)? = nil
    
    @Published var diameter = 1.0
    @Published var height = 0.1
    @Published var deltaDegree = 0.0
    var lastDegree = 0.0
    
    var songScorer: SongScorer! = nil
    var publisher: AnyCancellable! = nil
    
    var anchorPoint: CGPoint? = nil
    func anchorOnScreen() -> Bool {return anchorPoint != nil}
    
    @Published var mostRecentScore: Int? = nil
    func hasRecentScore() -> Bool {return mostRecentScore != nil}
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        songScorer = SongScorer(song: Jukebox.singleton.currentSong, parent: self)
        publisher = scene.publisher(for: SceneEvents.Update.self).sink(receiveValue: {[unowned self] in
            self.everyFrame(update:$0)
        })
        resetSession()
    }
    
    deinit {
        pause()
        songScorer.cancelAllPressed()
        InstrumentAppearance.singleton.removeFromParent()
    }
    
    required init?(coder decoder: NSCoder) {
        return nil
    }
    
    func resetSession() {
        let config = ARWorldTrackingConfiguration()
        session.run(config, options: [.resetTracking,.resetSceneReconstruction,.removeExistingAnchors])
    }
    
    var touchedBlacks = Set<Int>()
    var touchedWhites = Set<Int>()
    
    var sentScanningMessage = false
    func everyFrame(update: SceneEvents.Update) {
        if placing {
            if settingsSheet {return}
            if let potentialSpot = raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal).first {
                currentRayCast = potentialSpot
                if !sentScanningMessage {
                    DispatchQueue.main.asyncAfter(deadline: .now()+5.0, execute: {[weak self] in self?.doneScanning = true})
                    sentScanningMessage = true
                }
            }
            if doneScanning {
                let originTransform = Transform(matrix: currentRayCast!.worldTransform)
                anchorPoint = project(originTransform.translation)
            }
            objectWillChange.send()
        } else {
            if resizing {
                self.putDimensionsIntoEffect()
            } else if !showSheet && !settingsSheet {
                var newTouchedWhites = Set<Int>()
                var newTouchedBlacks = Set<Int>()
                for touch in currentTouches {
                    if let foundEntity = entity(at: touch.location(in: self)) {
                        var name = foundEntity.name
                        let last = name.removeLast()
                        let number = Int(name)!
                        switch last {
                        case "w":
                            newTouchedWhites.insert(number)
                        case "b":
                            newTouchedBlacks.insert(number)
                        default:
                            fatalError()
                        }
                    }
                }
                
                InstrumentAppearance.singleton.decoration.updateDecorations(dTime: Float(update.deltaTime))
                
                songScorer.update(newWhites: newTouchedWhites.subtracting(touchedWhites), oldWhites: touchedWhites.subtracting(newTouchedWhites), newBlacks: newTouchedBlacks.subtracting(touchedBlacks), oldBlacks: touchedBlacks.subtracting(newTouchedBlacks), timeInterval: update.deltaTime as Double, paused: paused)
                touchedWhites = newTouchedWhites
                touchedBlacks = newTouchedBlacks
            }
        }
    }
    
    func showSettings() {
        if !placing {
        pause()
        }
        settingsSheet = true
    }
    
    func unshowSettings() {
        settingsSheet = false
    }
    
    func startResizing() {
        pause()
        resizing = true
    }
    
    func stopResizing() {
        resizing = false
        updateAngle()
    }
    
    func updateAngle() {
        lastDegree = 0.0
        deltaDegree = 0.0
    }
    
    func placeOrigin() {
        guard let currentRayCast = currentRayCast else {fatalError()}
        let anchor = AnchorEntity(raycastResult: currentRayCast)
        
        let originTransform = Transform(matrix: currentRayCast.worldTransform)
        let toCamera = cameraTransform.translation - originTransform.translation
        let newVec: simd_float2 = normalize([toCamera.x,-toCamera.z])
        
        let arcTan = atan(newVec.y/newVec.x)
        let angle = newVec.x < .zero ? arcTan + .pi : arcTan
        InstrumentAppearance.singleton.setRotation(toRadians: angle)
        InstrumentAppearance.singleton.addTo(anchor: anchor)
        scene.addAnchor(anchor)
        
        self.placing = false
        resetScanningLogic()
    }
    
    func resetScanningLogic() {
        self.currentRayCast = nil
        self.doneScanning = false
        self.sentScanningMessage = false
        self.anchorPoint = nil
    }
    
    func play() {
        paused = false
        songScorer.play()
    }
    
    func setRecentScore(to: Int) {
        mostRecentScore = to
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {[weak self] in
            if let self = self {
                if let mostRecentScore = self.mostRecentScore {
                    if to == mostRecentScore {
                        self.mostRecentScore = nil
                    }
                }
            }
        })
    }
    
    func resetTouchLogic() {
        touchedBlacks.removeAll()
        touchedWhites.removeAll()
        songScorer.cancelAllPressed()
    }
    
    func toMainMenu() {
        AppController.singleton.toMainMenuView()
    }
    
    func pause() {
        resetTouchLogic()
        paused = true
        songScorer.pause()
    }
    
    func presentSheet(type: SheetType) {
        pause()
        sheetType = type
        showSheet = true
    }
    
    func unpresentSheet() {
        showSheet = false
    }
    
    func putDimensionsIntoEffect() {
        InstrumentAppearance.singleton.setHeight(to: height)
        InstrumentAppearance.singleton.setDiameter(to: Float(diameter))
        if deltaDegree != lastDegree {
            InstrumentAppearance.singleton.changeRotation(byRadians: toRadians(degrees: deltaDegree - lastDegree))
            lastDegree = deltaDegree
        }
    }
    
    func loadCurrentSong() {
        pause()
        InstrumentAppearance.singleton.removeNotesFromTubes()
        songScorer = .init(song: Jukebox.singleton.currentSong, parent: self)
    }
    
    func placeAgain() {
        pause()
        InstrumentAppearance.singleton.removeFromParent()
        songScorer.cancelAllPressed()
        resetSession()
        loadCurrentSong()
        showSheet = false
        doneScanning = false
        placing = true
    }
    
    func finishGame() {
        let finalScore = songScorer.currentScore
        let songName = songScorer.currentSong.name
        
        let currentHighScore = UserDefaults.standard.integer(forKey: songName)
        let gotNewHighScore = currentHighScore < finalScore
        
        if gotNewHighScore {
            UserDefaults.standard.set(finalScore, forKey: songName)
            
            if ScoreCache.singleton.highScores[songName]!.count >= 10 {
                let worstHighScore = ScoreCache.singleton.highScores[songName]!.last!.score
                if worstHighScore > finalScore {
                    return
                }
            }
            ScoreCache.singleton.possibleHighScores[songName] = finalScore
            ScoreCache.singleton.addPossibleHighScores()
        }
        loadCurrentSong()
        self.snapshot(saveToHDR: false, completion: {(image) in
            self.victoryData = (songName: songName, image: image!, score: finalScore, gotHighScore: gotNewHighScore)
            self.presentSheet(type: .victoryView)
        })
    }
    
    var currentTouches = Set<UITouch>()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if placing {return}
        currentTouches.formUnion(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if placing {return}
        currentTouches.subtract(touches)
    }
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if placing {return}
        currentTouches.subtract(touches)
    }
}
