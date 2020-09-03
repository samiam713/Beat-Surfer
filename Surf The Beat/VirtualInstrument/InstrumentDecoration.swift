//
//  InstrumentDecoration.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/9/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

class InstrumentDecoration {
    
    var sunMoonTime: Float = 0.0
    let sunMoonPeriod: Float = 60.0
    
    var lightTime: Float = 0.0
    let lightPeriod: Float = 6.0
    
    var surferTime: Float = 0.0
    
    var lights = [Entity]()
    
    // surfer placed a little in front of origin and scales proportional to height until certain "cap" (we don't want him too big)
    // he wobbles with period of 3 seconds
    // wobble is selected using random point on "unit circle" where x/y axis correspond to pitch then yaw
    var surferReset = 3.0
    let surfer = Entity()
    
    let sun: Entity
    let moon: Entity
    let sunAndMoon: Entity
    
    init(parent: InstrumentAppearance, lightPrefab: Entity, barPrefab: Entity, surferPrefab: Entity, sunAndMoon: Entity) {
        parent.tubeOrigin.addChild(barPrefab)
        
        surferPrefab.transform.translation = [0.0,0.0,0.15]
        surfer.addChild(surferPrefab)
        
        surfer.transform.translation = [0.0,0.25,-0.45]
        parent.tubeOrigin.addChild(surfer)
        
        let light = SpotLight()
        light.light.intensity *= 0.5
        light.transform.rotation = .init(angle: toRadians(degrees: 74.0), axis: [-1.0,0.0,0.0])
        light.transform.translation = [0,0.0141,-0.0172]
        
        lightPrefab.addChild(light)
        
        self.sunAndMoon = sunAndMoon
        self.sun = sunAndMoon.findEntity(named: "sun")!
        self.moon = sunAndMoon.findEntity(named: "moon")!
        
        let sunLight = PointLight()
        sunLight.light.intensity *= 0.25
        sunLight.light.color = .init(red: 1, green: 1, blue: 204.0/255.0, alpha: 1)
        sun.addChild(sunLight)
        
        let moonLight = PointLight()
        moonLight.light.intensity *= 0.25
        moonLight.light.color = .init(red: 204/255, green: 229.0/255.0, blue: 1, alpha: 1)
        moon.addChild(moonLight)
//        moon.isEnabled = false
        
        parent.tubeOrigin.addChild(sunAndMoon)
        
        for distance in [-0.25,0.25] as [Float] {
            let lightPrefab = lightPrefab.clone(recursive: true)
            lightPrefab.transform.translation = [distance,-0.085,0.025]
            barPrefab.addChild(lightPrefab)
            lights.append(lightPrefab)
        }
    }
    
    func updateDecorations(dTime: Float) {
        updateLights(dTime: dTime)
        updateSurfer(dTime: dTime)
        updateSunAndMoon(dTime: dTime)
    }
    
    private func updateLights(dTime: Float) {
        lightTime+=dTime
        
        if lightTime > lightPeriod {
            lightTime -= lightPeriod
        }
        
        let maxAngle: Float = toRadians(degrees: 45.0)
        
        let angle: Float = simd_mix(Float.zero, 2*Float.pi, lightTime/lightPeriod)
        let rotationAngle: Float = maxAngle*sin(angle)
        let rotationQuat = simd_quatf.init(angle: rotationAngle, axis: [0,1,0])
        
        lights[0].transform.rotation = rotationQuat
        lights[1].transform.rotation = rotationQuat
    }
    
    private func updateSunAndMoon(dTime: Float) {
        sunMoonTime+=dTime
        
        if sunMoonTime > sunMoonPeriod {
            sunMoonTime -= sunMoonPeriod
//            sun.isEnabled = true
//            moon.isEnabled = false
        } else if sunMoonTime > sunMoonPeriod*0.5 && sun.isEnabled {
//            sun.isEnabled = false
//            moon.isEnabled = true
        }
        
        let angle: Float = simd_mix(Float.zero, 2*Float.pi, sunMoonTime/sunMoonPeriod)
        
        sunAndMoon.transform.rotation = .init(angle: angle, axis: [0.0,0.0,1.0])
    }
    
    private func updateSurfer(dTime: Float) {
        surferTime+=dTime
        
        let maxDifference: Float = toRadians(degrees: 5.0)
        
        let widthPeriod: Float = 3.1
        let widthMultiplier: Float = Float(2)*Float.pi/widthPeriod
        
        let heightPeriod: Float = 2.7
        let heightMultiplier: Float = Float(2)*Float.pi/heightPeriod
        
        let currentWidthAngle = maxDifference*sin(surferTime*widthMultiplier)
        let currentHeightAngle = maxDifference*sin(surferTime*heightMultiplier)
        
        surfer.transform.rotation = simd_quatf.init(angle: currentWidthAngle, axis: [0.0,1.0,0.0])*simd_quatf.init(angle: currentHeightAngle, axis: [1.0,0.0,0.0])
    }
}
