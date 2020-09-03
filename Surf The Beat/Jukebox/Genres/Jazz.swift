//
//  Jazz1.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

let jazz0 = Song(name: "Test Song", fileName: "Jazz0.mp3", songLength: 32.0, timePerNote: 1.0, orderedNotes: [
    Note(noteNum: 9, startTime: 2, type: .continuous(time: 2), color: .white),
    Note(noteNum: 8, startTime: 4, type: .continuous(time: 2), color: .white),
    Note(noteNum: 7, startTime: 6, type: .continuous(time: 2), color: .white),
    
    Note(noteNum: 9, startTime: 9, type: .continuous(time: 2), color: .white),
    Note(noteNum: 8, startTime: 11, type: .continuous(time: 2), color: .white),
    Note(noteNum: 7, startTime: 13, type: .continuous(time: 2), color: .white),
    
    Note(noteNum: 7, startTime: 16, type: .discrete, color: .white),
    Note(noteNum: 7, startTime: 17, type: .discrete, color: .white),
    Note(noteNum: 7, startTime: 18, type: .discrete, color: .white),
    Note(noteNum: 7, startTime: 19, type: .discrete, color: .white),
    
    Note(noteNum: 8, startTime: 20, type: .discrete, color: .white),
    Note(noteNum: 8, startTime: 21, type: .discrete, color: .white),
    Note(noteNum: 8, startTime: 22, type: .discrete, color: .white),
    Note(noteNum: 8, startTime: 23, type: .discrete, color: .white),
    
    Note(noteNum: 9, startTime: 24, type: .continuous(time: 2), color: .white),
    Note(noteNum: 8, startTime: 26, type: .continuous(time: 2), color: .white),
    Note(noteNum: 7, startTime: 28, type: .continuous(time: 2), color: .white),
])

let jazz = Genre(name: "Jazz", songs: [
jazz0
])
