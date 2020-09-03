//
//  Classical.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/9/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

let flightOfTheValkyries = Song(name: "Flight of the Valkyries", fileName: "FlightOfValks.aif", songLength: 60.0, timePerNote: 0.3, orderedNotes: [
    .init(noteNum: 13, startTime: 14*8+5, type: .continuous(time: 1), color: .white),
    .init(noteNum: 10, startTime: 14*8+6, type: .discrete, color: .black),
    .init(noteNum: 13, startTime: 14*8+7, type: .continuous(time: 1), color: .white),
    .init(noteNum: 15, startTime: 15*8, type: .continuous(time: 3), color: .white),
    .init(noteNum: 13, startTime: 15*8+3, type: .continuous(time: 3), color: .white),
    .init(noteNum: 15, startTime: 15*8+6, type: .continuous(time: 1), color: .white),
    .init(noteNum: 13, startTime: 15*8+7, type: .discrete, color: .white),
    .init(noteNum: 15, startTime: 16*8, type: .continuous(time: 1), color: .white),
    .init(noteNum: 17, startTime: 16*8+1, type: .continuous(time: 3), color: .black),
    .init(noteNum: 15, startTime: 16*8+4, type: .continuous(time: 3), color: .white),
    .init(noteNum: 17, startTime: 16*8+7, type: .continuous(time: 1), color: .black),
    .init(noteNum: 15, startTime: 17*8, type: .discrete, color: .white),
    .init(noteNum: 17, startTime: 17*8+1, type: .continuous(time: 1), color: .black),
    .init(noteNum: 19, startTime: 17*8+2, type: .continuous(time: 3), color: .white),
    .init(noteNum: 12, startTime: 17*8+5, type: .continuous(time: 3), color: .white),
    .init(noteNum: 15, startTime: 18*8, type: .continuous(time: 1), color: .white),
    .init(noteNum: 12, startTime: 18*8+1, type: .discrete, color: .white),
    .init(noteNum: 15, startTime: 18*8+2, type: .continuous(time: 1), color: .white),
    .init(noteNum: 17, startTime: 18*8+3, type: .continuous(time: 15), color: .black),
    .init(noteNum: 15, startTime: 22*8+4, type: .continuous(time: 1), color: .white),
    .init(noteNum: 12, startTime: 22*8+5, type: .discrete, color: .white),
    .init(noteNum: 15, startTime: 22*8+6, type: .continuous(time: 1), color: .white),
    .init(noteNum: 17, startTime: 22*8+7, type: .continuous(time: 3), color: .black),
    .init(noteNum: 15, startTime: 23*8+2, type: .continuous(time: 3), color: .white),
    .init(noteNum: 17, startTime: 23*8+5, type: .continuous(time: 1), color: .black),
    .init(noteNum: 15, startTime: 23*8+6, type: .discrete, color: .white),
    .init(noteNum: 17, startTime: 23*8+7, type: .continuous(time: 1), color: .black),
    .init(noteNum: 19, startTime: 24*8, type: .continuous(time: 3), color: .white),
    .init(noteNum: 17, startTime: 24*8+3, type: .continuous(time: 3), color: .black),
    .init(noteNum: 19, startTime: 24*8+6, type: .continuous(time: 1), color: .white),
    .init(noteNum: 17, startTime: 24*8+7, type: .discrete, color: .black),
    .init(noteNum: 19, startTime: 25*8, type: .continuous(time: 1), color: .white),
    .init(noteNum: 21, startTime: 25*8+1, type: .continuous(time: 3), color: .black),
    .init(noteNum: 14, startTime: 25*8+4, type: .continuous(time: 3), color: .black),
    .init(noteNum: 17, startTime: 25*8+7, type: .continuous(time: 1), color: .black),
    .init(noteNum: 14, startTime: 26*8, type: .discrete, color: .black),
    .init(noteNum: 17, startTime: 26*8+1, type: .continuous(time: 1), color: .black),
    .init(noteNum: 19, startTime: 26*8+2, type: .continuous(time: 15), color: .black),
    
])

let classical = Genre(name: "Classical", songs: [
    flightOfTheValkyries,
    ])
