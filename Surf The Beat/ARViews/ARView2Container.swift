//
//  ContentView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @ObservedObject var arView2: ARView2
    var body: some View {
        ZStack {
            ARViewContainer(arView2: arView2)
                .edgesIgnoringSafeArea(.all)
            if arView2.doneScanning && arView2.anchorOnScreen() {
                Circle()
                    .fill(Color.black)
                    .frame(width: 20.0, height: 20.0)
                    .position(arView2.anchorPoint!)
            }
            if arView2.placing {
                PlacingOverlay(arView2: arView2)
            } else {
                if arView2.resizing {
                    ResizeOverlay(arView2: arView2)
                } else {
                    PlacedOverlay(arView2: arView2)
                }
            }
            if arView2.hasRecentScore() {
                Text("+\(arView2.mostRecentScore!)").font(shagadelic())
            }
        }
        .actionSheet(isPresented: $arView2.settingsSheet, content: {
            makeSettingsSheet(arView2: arView2)
        })
            .sheet(isPresented: $arView2.showSheet, content: { // you're gonna have to break this a 4-case enum to add VictoryView / ManualView
                if self.arView2.sheetType == .loadSong {
                    SongSelectorView()
                } else if self.arView2.sheetType == .manual {
                    ManualView()
                } else if self.arView2.sheetType == .victoryView {
                    VictoryView(arView2: self.arView2)
                } else if self.arView2.sheetType == .socialSharer {
                    SocialSharer(activityItems: [
                        self.arView2.victoryData!.image,
                        "I got a score of \(self.arView2.victoryData!.score) on \"\(self.arView2.victoryData!.songName)\". \(self.arView2.victoryData!.gotHighScore ? "If you couldn't tell that's a high score. " : "")Think you can do better?😉"
                    ])
                }
            })
        
    }
    
    //        .sheet(isPresented: <#T##Binding<Bool>#>, content: <#T##() -> View#>) MODIFY APPEARANCE
    //  .sheet FOR DISPLAYING VICTORY! Basically when this is displayed check if you need to update high score and make SM post saying score on song
    
}


struct ARViewContainer: UIViewRepresentable {
    
    let arView2: ARView2
    
    func makeUIView(context: Context) -> ARView {
        return arView2
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
