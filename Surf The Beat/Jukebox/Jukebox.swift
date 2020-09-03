//
//  SongSelector.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

let genres = [jazz, classical]

class Jukebox: ObservableObject {
    
    static var singleton = Jukebox()
    
    @Published var currentSong = jazz0

    @Published var genreIndex = 0
    
    func updateCurrent(song: Song) {
        currentSong = song
        switch AppController.singleton.state {
        case .arDisplay(let arView2):
            arView2.loadCurrentSong()
        default:
            return
        }
    }
}
