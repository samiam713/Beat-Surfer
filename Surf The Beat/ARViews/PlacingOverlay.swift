//
//  PlacingOverlay.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct PlacingOverlay: View {
    
    @ObservedObject var arView2: ARView2
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            VStack {
                HStack {
                    //                    Button.init(action: AppController.singleton.toMainMenuView, label: {
                    //                        Image(systemName: "chevron.left.circle.fill")
                    //                            .font(.title)
                    //                    })
                    Spacer()
                    Button.init(action: self.arView2.showSettings) {
                        Image(systemName: "gear")
                            .font(.title)
                            .padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                .foregroundColor(.white)
                        )
                    }
                }
                .padding()
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                        .foregroundColor(.black)
                    HStack {
                        if self.arView2.doneScanning {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        } else {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            
                        }
                        if self.arView2.doneScanning {
                            Button("Tap to place!", action: self.arView2.placeOrigin)
                        } else {
                            Text("Scan to tap to place!")
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: proxy.size.width*0.6, height: proxy.size.height/12.0, alignment: .center)
                .padding()
                
            }
        }
    }
}

