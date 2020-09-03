//
//  AppDelegate.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import UIKit
import SwiftUI

class AppController {
    static var singleton: AppController!
    
    let window: UIWindow
    var state: State = .mainMenu
    //    let jukebox = Jukebox()
    
    enum State {
        case mainMenu
        case arDisplay(ARView2)
    }
    
    init() {
        self.window = .init(frame: UIScreen.main.bounds)
        self.window.makeKeyAndVisible()
        toMainMenuView()
        InstrumentAppearance.scene = try! Experience.loadBox()
//        Experience.loadBoxAsync(completion: {result in
//            switch result {
//            case .success(let scene):
//                InstrumentAppearance.scene = scene
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            }
//        })
    }
}

extension AppController {
    func toMainMenuView() {
        state = .mainMenu
        window.rootViewController = UIHostingController(rootView: MainMenuView())
    }
    //
    //    func toVictoryView(songName: String, image: UIImage, score: Int, gotHighScore: Bool) {
    //        window.rootViewController = UIHostingController(rootView: VictoryView(songName: songName, image: image, score: score, gotHighScore: gotHighScore))
    //        state = .victoryView
    //    }
    
    func toARView(height: Double, diameter: Double) {
        InstrumentAppearance.loadSingleton()
        InstrumentSound.loadSingleton()
        ScoreCache.loadSingleton()
        
        let arView2 = ARView2(frame: .zero)
        state = .arDisplay(arView2)
        
        arView2.diameter = diameter
        arView2.height = height
        
        arView2.putDimensionsIntoEffect()
        
        window.rootViewController = UIHostingController(rootView: ContentView(arView2: arView2))
    }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create the SwiftUI view that provides the window contents.
        AppController.singleton = .init()
        fontHelper()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        switch AppController.singleton.state {
        case .arDisplay(let arView2):
            if !arView2.placing && !arView2.paused {arView2.pause()}
        default:
            return
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

