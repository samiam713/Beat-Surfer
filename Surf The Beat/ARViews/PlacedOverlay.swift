//
//  PlacedOverlay.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct PlacedOverlay: View {
    
    @ObservedObject var arView2: ARView2
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            VStack {
                HStack {
                    VStack {
                        Text("Current Score: \(self.arView2.songScorer.currentScore)")
                        Text("High Score: \(UserDefaults.standard.integer(forKey: self.arView2.songScorer.currentSong.name))")
                        Text("\(self.arView2.songScorer.currentSong.name)").italic()
                    }
                .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: proxy.size.width/50.0)
                    .foregroundColor(.init(white: 0.0, opacity: 0.5))
                    )
                    Spacer()
                    Button.init(action: self.arView2.showSettings) {
                        Image(systemName: "gear")
                            .font(.title)
                            .padding(proxy.size.width/20.0)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                        .foregroundColor(.white)
                        )
                    }
                }
                .padding()
                Spacer()
                HStack {
                    Button.init(action: {self.arView2.presentSheet(type: .loadSong)}) {
                        ZStack {
                            RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                .fill(gradientMaker(top: oceanBlue, bottom: sandEnd))
                            Text("Select Song")
                                .multilineTextAlignment(.center)
                                .font(shagadelic())
                                .foregroundColor(.black)
                        }
                        .frame(width: proxy.size.width/4.0, height: proxy.size.height/12.0, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                    if self.arView2.paused {
                        Button(action: self.arView2.play, label: {
                            Image(systemName: "play.rectangle.fill")
                                .font(.title)
                                 .padding(proxy.size.width/20.0)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                            .foregroundColor(.white)
                            )
                        })
                    } else {
                        Button(action: self.arView2.pause, label: {
                            Image(systemName: "pause.rectangle.fill")
                                .font(.title)
                                 .padding(proxy.size.width/20.0)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                            .foregroundColor(.white)
                            )
                        })
                    }
                    Divider()
                    Button.init(action: self.arView2.startResizing) {
                        ZStack {
                            RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                .fill(gradientMaker(top: oceanBlue, bottom: sandEnd))
                            Text("Resize")
                                .multilineTextAlignment(.center)
                                .font(shagadelic())
                                .foregroundColor(.black)
                        }
                        .frame(width: proxy.size.width/4.0, height: proxy.size.height/12.0, alignment: .center)
                    }
                }
                .frame(height: proxy.size.height/10)
                .padding()
            }
        }
    }
    
    //    var body: some View {
    //        VStack {
    //            Spacer()
    //            Button("Load Song", action: {
    //                self.arView2.presentSheet(type: .loadSong)
    //            })
    //            Spacer()
    //            if arView2.paused {
    //                Button(action: arView2.play, label: {
    //                    Image(systemName: "play.rectangle.fill")
    //                    .font(Font.system(.title))
    //                })
    //            } else {
    //                Button(action: arView2.pause, label: {
    //                    Image(systemName: "pause.rectangle.fill")
    //                    .font(Font.system(.title))
    //                })
    //            }
    //            Spacer()
    //            Button("Settings", action: {
    //                self.arView2.presentSheet(type: .dimension)
    //            })
    //            Spacer()
    //        }
    //    }
}
