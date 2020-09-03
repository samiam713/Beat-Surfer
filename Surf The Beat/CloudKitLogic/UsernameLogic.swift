//
//  TheCloud.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/17/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

class UsernameLogic: ObservableObject {
    
    static let singleton: UsernameLogic = .init()
    
    @Published var potentialUsername: String
    @Published var actualUsername: String
    @Published var lastUNAttemptFailed = false
    
    private init() {
        if let username = UserDefaults.standard.string(forKey: "scoreUsername") {
            self.actualUsername = username
            self.potentialUsername = ""
        } else {
            let username = Self.generateUsername()
            self.actualUsername = username
            self.potentialUsername = ""
            
        }
    }
    
    func refreshUsernameChanging() {
        self.potentialUsername = ""
        self.lastUNAttemptFailed = false
    }
    
    func attemptToSaveUsername() {
        if validUsername(username: potentialUsername) {
            actualUsername = potentialUsername
            UserDefaults.standard.set(actualUsername, forKey: "scoreUsername")
            lastUNAttemptFailed = false
        } else {
            lastUNAttemptFailed = true
        }
    }
    
    func validUsername(username: String) -> Bool {
        
        // let charCheck = username.allSatisfy({$0.isLetter || $0.isNumber || $0 == " "}) &&
        
        if (3...15).contains(username.count) {
            let badSubstrings = ["ass","shit","fuck","nigger","beaner","chink","tit","cunt","whore","dick","damn"]
            let lowercased = username.lowercased()
            return badSubstrings.allSatisfy({!lowercased.contains($0)})
        } else {
            return false
        }
    }
    
    static func generateUsername() -> String {
        let prefixes = ["The_Kid","Da_Beast","Mr.Muscle","Dr.Finessor","Auntie","Egg_Head",
                        "Grass_Man","Froggie","Slim_Boy","Poppa_Fat","Jokster","Anonymous",
                        "Cowman","The_Player","Some_Nihilist","Alpha_Leader","Serious_Bob","Mrs.Grey"]
        return prefixes.randomElement()! + "\(Int.random(in: 0...9))\(Int.random(in: 0...9))"
    }

}
