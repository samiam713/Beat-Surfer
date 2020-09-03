//
//  PhysicalManager.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

func validBlack(index: Int) -> Bool {
    let blacks: Set<Int> = [0,1,3,4,5]
    return blacks.contains(index%7) && index != 28
}


class InstrumentAppearance {
    // the manager of three types entities...
    // the "stand" and the "tubules" and the "buttons"
    
    // these entities must be rooted around some origin at the ground so that to change height you change translation of "stand" and "buttons" and y-scale of "tubules" and to change scale you "change scale of origin"
    // attach these entities to a scene at the appropriate angle using the camera transform
    
    static var singleton: InstrumentAppearance! = nil
    
    static func loadSingleton() {
        if singleton == nil {
            singleton = .init()
        }
    }
    
    static var scene: Experience.Box! = nil
    
    let whiteCover: Entity
    let blackCover: Entity
    
    var whiteTubes = [Entity]()
    var blackTubes = [Int:Entity]()
    
    let standOrigin = Entity()
    let tubeOrigin = Entity()
    
    let origin = Entity()
    
    let discreteNote: Entity
    let longNote = Entity()
    
    var activeWhites = [Note:Entity]()
    var activeBlacks = [Note:Entity]()
    
    var decoration: InstrumentDecoration! = nil
    
    init() {
        
        // get entities in right spots in memory
        
        let scene = InstrumentAppearance.scene!
        
        self.whiteCover = scene.whiteCover!
        self.blackCover = scene.blackCover!
        
        self.whiteCover.transform = Transform()
        self.blackCover.transform = Transform()
        
        let supporter = scene.supporter!
        
        let whiteTube = scene.whiteTube!
        let whiteButton = scene.whiteButton!
        
        let blackTube = scene.blackTube!
        let blackButton = scene.blackButton!
        
        discreteNote = scene.discreteNote!
        
        scene.longNote!.transform.translation = [0.0,0.03,0.0]
        longNote.addChild(scene.longNote!)
        
        origin.addChild(standOrigin)
        origin.addChild(tubeOrigin)
        
        // occlusion logic pt1:
        
        let lowOcclusionBox = ModelEntity(mesh: .generateBox(size: [1.2,0.5,0.5]), materials: [OcclusionMaterial()])
        lowOcclusionBox.transform.translation = [0.0,-0.25,0.0]
        standOrigin.addChild(lowOcclusionBox)
        
        let maxNote = 28
        
        let baseVector: simd_float3 = [0.0,0.0,1.0]
        let whiteDifferenceVector: simd_float3 = [-0.5,0.0,-1.0]
        let blackDifferenceVector: simd_float3 = [-0.48337337, 0.0, -1.008142]*1.1
        
        let maximumAngle: Float = 0.9272952180016123
        
        func prefabUtility(prefab: Entity, x: Float, z: Float, origin: Entity) -> Entity {
            let newPrefab = prefab.clone(recursive: true)
            newPrefab.transform.translation.x = x
            newPrefab.transform.translation.z = z
            origin.addChild(newPrefab)
            return newPrefab
        }
        
        for note in 0...maxNote {
            let rotation = simd_quatf(angle: maximumAngle*(Float(note)/Float(maxNote)), axis: [0.0,-1.0,0.0])
            
            if validBlack(index: note) {
                // add black
                let newBlackPosition = baseVector + rotation.act(blackDifferenceVector)
                blackTubes[note] = prefabUtility(prefab: blackTube, x: newBlackPosition.x, z: newBlackPosition.z, origin: tubeOrigin)
                let newBlackButton = prefabUtility(prefab: blackButton, x: newBlackPosition.x, z: newBlackPosition.z, origin: tubeOrigin)
                newBlackButton.name = "\(note)b"
                
                _ = prefabUtility(prefab: supporter, x: newBlackPosition.x, z: newBlackPosition.z, origin: standOrigin)
            }
            
            // add white
            let newWhitePosition = baseVector + rotation.act(whiteDifferenceVector)
            whiteTubes.append(prefabUtility(prefab: whiteTube, x: newWhitePosition.x, z: newWhitePosition.z, origin: tubeOrigin))
            let newWhiteButton = prefabUtility(prefab: whiteButton, x: newWhitePosition.x, z: newWhitePosition.z, origin: tubeOrigin)
            newWhiteButton.name = "\(note)w"
            
            _ = prefabUtility(prefab: supporter, x: newWhitePosition.x, z: newWhitePosition.z, origin: standOrigin)
        }
        
        self.decoration = InstrumentDecoration(parent: self, lightPrefab: scene.light!, barPrefab: scene.lightBar!, surferPrefab: scene.beatSurfer!, sunAndMoon: scene.sunAndMoon!)
        
        defer {
            // place children of tubeOrigin on XZ plane of origin as last thing (make sure is last bc of InstrumentDecorations)
            for child in tubeOrigin.children {
                child.transform.translation -= [0.0,0.1,0.0]
            }
            tubeOrigin.transform.translation += [0.0,0.1,0.0]
        }
    }
    
    var buttonCovers = [String:Entity]()
    
    func addButtonCover(id: String, targetButton: Entity, white: Bool) {
        let newCover = (white ? whiteCover : blackCover).clone(recursive: true)
        targetButton.addChild(newCover)
        buttonCovers[id] = newCover
    }
    
    func removeButtonCover(id: String) {
        guard let oldCover = buttonCovers[id] else {fatalError()}
        oldCover.removeFromParent()
        buttonCovers[id] = nil
    }
    
    func pressWhite(index: Int) {
        let name = "\(index)w"
        guard let button = origin.findEntity(named: name) else {fatalError()}
        addButtonCover(id: name, targetButton: button, white: true)
    }
    
    func pressBlack(index: Int) {
        let name = "\(index)b"
        guard let button = origin.findEntity(named: name) else {fatalError()}
        addButtonCover(id: name, targetButton: button, white: false)
    }
    
    func unpressWhite(index: Int) {
        let name = "\(index)w"
        removeButtonCover(id: name)
    }
    
    func unpressBlack(index: Int) {
        let name = "\(index)b"
        removeButtonCover(id: name)
    }
    
    func updateNotes(distance: Float) {
        for value in activeWhites.values {
            value.transform.translation -= [0.0,distance,0.0]
        }
        for value in activeBlacks.values {
            value.transform.translation -= [0.0,distance,0.0]
        }
    }
    
    func addTo(anchor: AnchorEntity) {
        anchor.addChild(origin)
    }
    
    func removeFromParent() {
        removeNotesFromTubes()
        origin.removeFromParent()
    }
    
    func removeNotesFromTubes() {
        for (_,noteEntity) in activeWhites {
            noteEntity.removeFromParent()
        }
        for (_,noteEntity) in activeBlacks {
            noteEntity.removeFromParent()
        }
        activeWhites.removeAll()
        activeBlacks.removeAll()
    }
    
    func addNote(note: Note) {
        var prefab: Entity
        switch note.type {
        case .continuous(time: let time):
            prefab = longNote.clone(recursive: true)
            prefab.transform.scale = [1.0,Float(time) - Float(InstrumentSound.timeShaved),1.0]
            prefab.transform.translation = .zero
        case .discrete:
            prefab = discreteNote.clone(recursive: true)
            prefab.transform.translation = [0.0,0.03,0.0]
        }
        switch note.color {
        case .black:
            prefab.transform.translation += [0.0,0.54,0.0]
            blackTubes[note.noteNum]!.addChild(prefab)
            activeBlacks[note] = prefab
        case .white:
            prefab.transform.translation += [0.0,0.48,0.0]
            whiteTubes[note.noteNum].addChild(prefab)
            activeWhites[note] = prefab
        }
    }
    
    func removeNote(note: Note) {
        switch note.color {
        case .black:
            activeBlacks[note]?.removeFromParent()
        case .white:
            activeWhites[note]?.removeFromParent()
        }
    }
    
    func setHeight(to: Double) {
        let originalHeight = 0.1
        let heightMultiplier = to/originalHeight
        
        tubeOrigin.transform.translation = [0.0,Float(to),0.0]
        standOrigin.transform.scale.y = Float(heightMultiplier)
    }
    
    func setDiameter(to: Float) {
        tubeOrigin.scale = .init(repeating: to)
        standOrigin.scale.x = to
        standOrigin.scale.z = to
    }
    
    func setRotation(toRadians: Float) {
        origin.transform.rotation = simd_quatf.init(angle: .pi*0.5+Float(toRadians), axis: [0.0,1.0,0.0])
    }
    
    func changeRotation(byRadians: Double) {
        origin.transform.rotation = simd_quatf.init(angle: Float(byRadians), axis: [0.0,-1.0,0.0])*origin.transform.rotation
    }
}
