//
//  ScoreCache.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/21/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import CloudKit

struct HighScoreData: Codable {
    
    static let recordName = "SongHighScore"
    
    let songName: String
    let score: Int
    let userID: String
    
    internal init(songName: String, score: Int, userID: String) {
        self.songName = songName
        self.score = score
        self.userID = userID
    }
    
    init(record: CKRecord) {
        self.songName = record["songName"] as! String
        self.score = record["score"] as! Int
        self.userID = record["userID"] as! String
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: HighScoreData.recordName)
        
        record["songName"] = songName
        record["score"] = score
        record["userID"] = userID
        
        return record
    }
}

class ScoreCache: Codable, ObservableObject {
    
    static var singleton: ScoreCache! = nil
    
    static func loadSingleton() {
        
        let scoreCache: ScoreCache
        
        if let fileData = try? Data(contentsOf: ScoreCache.scoreCacheURL), let selfDecoded = try? ScoreCache.decoder.decode(ScoreCache.self, from: fileData) {
            scoreCache = selfDecoded
        } else {
            scoreCache = .init()
        }
        
        for genre in genres {
            for song in genre.songs {
                scoreCache.updateHighScores(forSongNamed: song.name)
            }
        }
        
        scoreCache.addPossibleHighScores()
        
        Self.singleton = scoreCache
    }
    
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static let scoreCacheURL = getDocumentsDirectory()
        .appendingPathComponent("scoreCache", isDirectory: false)
        .appendingPathExtension("json")
    
    var highScores = [String:[HighScoreData]]() {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    var possibleHighScores = [String:Int]()
    
    init() {
        for genre in genres {
            for song in genre.songs {
                highScores[song.name] = []
            }
        }
    }
    
    deinit {
        do {
            let fileData = try ScoreCache.encoder.encode(self)
            try fileData.write(to: ScoreCache.scoreCacheURL)
        } catch {
            fatalError("CHANGE ME IF THIS HAPPENS")
        }
    }
    
    func updateHighScores(forSongNamed: String) {
        // fetches all records that are a high score on this song name
        
        let query = CKQuery(recordType: HighScoreData.recordName, predicate: .init(format: "songName = %@", forSongNamed))
        
        ScoreCache.publicDatabase.perform(query, inZoneWith: nil, completionHandler: {(records: [CKRecord]?, error: Error?) in
            if let records = records {
                let highScores = records.map({HighScoreData(record: $0)}).sorted(by: {(lhs,rhs) in lhs.score >= rhs.score})
                self.highScores[forSongNamed] = highScores
            } else {
                
            }
        })
    }
    
    func addPossibleHighScores() {
        for (songName,score) in possibleHighScores {
            let query = CKQuery(recordType: HighScoreData.recordName, predicate: .init(format: "songName = %@", songName))
            ScoreCache.publicDatabase.perform(query, inZoneWith: nil, completionHandler: {(records: [CKRecord]?, error: Error?) in
                if let records = records {
                    var highScores = records.map({HighScoreData(record: $0)}).sorted(by: {(lhs,rhs) in lhs.score >= rhs.score})
                    let potentialElement = HighScoreData(songName: songName, score: score, userID: UsernameLogic.singleton.actualUsername)
                    if highScores.count < 10 {
                        if let index = highScores.firstIndex(where: {$0.score <= score}) {
                            highScores.insert(potentialElement, at: index)
                        } else {
                            highScores.append(potentialElement)
                        }
                        self.highScores[songName] = highScores
                        ScoreCache.publicDatabase.save(potentialElement.toRecord(), completionHandler: {if $1 == nil {self.possibleHighScores[songName] = nil}
                        })
                    } else if let index = highScores.firstIndex(where: {$0.score <= score}) {
                        highScores.insert(potentialElement, at: index)
                        let worstElement = highScores.popLast()!
                        self.highScores[songName] = highScores
                        
                        let worstRecordIndex = records.firstIndex(where: {
                            let userIDMatch = worstElement.userID == $0["userID"] as! String
                            let scoreMatch = worstElement.score == $0["score"] as! Int
                            return userIDMatch && scoreMatch
                        })!
                        ScoreCache.publicDatabase.delete(withRecordID: records[worstRecordIndex].recordID, completionHandler: {
                            guard $1 == nil else {return}
                            ScoreCache.publicDatabase.save(potentialElement.toRecord(), completionHandler: {if $1 == nil {self.possibleHighScores[songName] = nil}
                               })
                        })
                    } else {
                        self.possibleHighScores[songName] = nil
                    }
                }
            })
            
        }
    }
}
