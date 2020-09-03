//
//  ResizeOverlay.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct ResizeOverlay: View {
    
    @ObservedObject var arView2: ARView2
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            VStack {
                Spacer()
                Text("Width: \(digitApproximator(arg: self.arView2.diameter, digits: 2)) m")
                Slider(value: self.$arView2.diameter, in: 0.2...1.75)
                    .padding()
                Text("Height: \(digitApproximator(arg: self.arView2.height, digits: 2)) m")
                Slider(value: self.$arView2.height, in: 0.05...1.0)
                    .padding()
                Text("Rotate Instrument: \(digitApproximator(arg: self.arView2.deltaDegree, digits: 2))°")
                Slider(value: self.$arView2.deltaDegree, in: -180.0...180.0)
                    .padding()
                Button(action: self.arView2.stopResizing, label: {
                    Image(systemName: "return")
                        .font(.title)
                        .padding(proxy.size.width/20.0)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                            .foregroundColor(.white)
                    )
                })
            }
        }
    }
}

