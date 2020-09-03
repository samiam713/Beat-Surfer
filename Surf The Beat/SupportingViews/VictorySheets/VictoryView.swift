//
//  VictoryView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 4/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct VictoryView: View {
    
    let arView2: ARView2
    let data: (songName: String, image: UIImage, score: Int, gotHighScore: Bool)
    
    init(arView2: ARView2) {
        self.arView2 = arView2
        self.data = arView2.victoryData!
    }
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            ZStack {
                Image(uiImage: self.data.image)
                    .resizable()
                    .scaledToFit()
                VStack {
                    Spacer()
                    Button.init(action: {self.arView2.presentSheet(type: .socialSharer)}) {
                        
                        Text("SHARE!").font(shagadelic()).foregroundColor(.white)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: proxy.size.width/20.0)
                    .fill(LinearGradient(gradient: .init(colors: [.gray,.black]), startPoint: .top, endPoint: .bottom))
                    )
                    Divider()
                    VStack {
                        if self.data.gotHighScore {Text("High Score!").bold().font(shagadelic())}
                        Text("Final Score: \(self.data.score)").font(shagadelic())
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: proxy.size.width/20.0)
                    .fill(LinearGradient(gradient: .init(colors: [.gray,.black]), startPoint: .top, endPoint: .bottom))
                    )
                }
                .padding()
            }
        }
    }
}

//struct VictoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        VictoryView()
//    }
//}
