//
//  Song.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

struct Note: Hashable {
    enum NoteType: Hashable {
        case continuous(time: Int)
        case discrete
    }
    
    enum NoteColor: Hashable {
        case white
        case black
    }
    
    let noteNum: Int // [0,28]
    let startTime: Int // [0,INF)
    
    let type: NoteType
    let color: NoteColor
}

struct Song: Hashable {
    let name: String
    let fileName: String
    let songLength: Double
    let timePerNote: Double
    let orderedNotes: [Note]
}

struct Genre: Hashable {
    let name: String
    let songs: [Song]
}


// if you press a note at a time that overlaps a theoretical note (and that theoretical note hasn't been "played already")
