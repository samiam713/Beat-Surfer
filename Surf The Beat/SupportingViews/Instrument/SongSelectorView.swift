//
//  SongSelectorView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct SongSelectorView: View {
    
    @ObservedObject var jukebox = Jukebox.singleton
    
    var body: some View {
        VStack {
            SongView(song: jukebox.currentSong)
            
            Picker("Select Genre", selection: $jukebox.genreIndex) {
                ForEach(genres.indices) {
                    Text(genres[$0].name)
                }
            }
            List(genres[jukebox.genreIndex].songs, id: \.name, rowContent: {(song: Song) -> Button<SongViewBar> in
                Button.init(action: {
                    self.jukebox.updateCurrent(song: song)
                }, label: {
                    SongViewBar(song: song)
                })
            })
        }
        .pickerStyle(SegmentedPickerStyle())
        .navigationBarTitle("The Song")

    }
}

struct SongViewBar: View {
    let song: Song
    
    var body: some View {
        HStack {
            Text("\(song.name)").italic()
            Spacer()
            Text("Time: \(Int(song.songLength.rounded(FloatingPointRoundingRule.up))) s")
                .font(.footnote)
            Divider()
            Text("HighScore: \(UserDefaults.standard.integer(forKey: song.name))").font(.footnote)
        }
    }
}

struct SongView: View {
    let song: Song
    
    var body: some View {
        VStack {
            Text("\(song.name)").font(.title).italic().padding([.top], nil)
            HStack {
            Text("Time: \(Int(song.songLength.rounded(FloatingPointRoundingRule.up))) s")
                .font(.footnote)
            Divider()
            Text("High Score: \(UserDefaults.standard.integer(forKey: song.name))").font(.footnote)
            }
        }
        .frame(maxHeight: 100.0)
    }
}
