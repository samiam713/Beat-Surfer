//
//  ConfigurationView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/14/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct ConfigurationView: View {
    
    @State var diameter = 1.0
    @State var height = 0.1
    
    var body: some View {
        GeometryReader {(outerProxy: GeometryProxy) in
            VStack {
                GeometryReader {(proxy: GeometryProxy) in
                    ZStack {
                        Image("NewHeightComparison")
                            .resizable()
                            .scaledToFit()
                        Rectangle()
                            .frame(width: proxy.size.width * CGFloat(self.diameter/1.75), height: proxy.size.height * CGFloat(self.height/1.75), alignment: .center)
                            .foregroundColor(.gray)
                            .position(x: proxy.size.width/2.0, y: proxy.size.height * (1 - CGFloat(self.height/(1.75*2))))
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: proxy.size.width * CGFloat(self.diameter/1.75), height: proxy.size.height * CGFloat(0.1/1.75) + 20.0, alignment: .center)
                            .foregroundColor(.black)
                            .position(x: proxy.size.width/2.0, y: proxy.size.height * (1 - CGFloat(self.height/1.75) - 0.15/1.75) + 10.0)
                        RoundedRectangle(cornerRadius: 5.0)
                            .frame(width: proxy.size.width * CGFloat(self.diameter/1.75), height: proxy.size.height * CGFloat(0.1/1.75), alignment: .center)
                            .foregroundColor(.white)
                            .position(x: proxy.size.width/2.0, y: proxy.size.height * (1 - CGFloat(self.height/1.75) - 0.05/1.75))
                    }
                }
                .frame(width: 0.9*outerProxy.size.width, height: 0.9*outerProxy.size.width, alignment: .center)
                Text("Image for Scale").font(.caption).foregroundColor(.gray)
                Divider()
                Text("Width: \(digitApproximator(arg: self.diameter, digits: 2)) m")
                Slider(value: self.$diameter, in: 0.2...1.75)
                    .padding()
                Text("Height: \(digitApproximator(arg: self.height, digits: 2)) m")
                Slider(value: self.$height, in: 0.05...1.0)
                    .padding()
                Button.init(action: {AppController.singleton.toARView(height: self.height, diameter: self.diameter)}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: outerProxy.size.width/25.0)
                            .fill(gradientMaker(top: oceanBlue, bottom: sandEnd))
                        Text("Load Instrument")
                            .multilineTextAlignment(.center)
                            .font(shagadelic())
                            .foregroundColor(.black)
                    }
                    .frame(width: 0.9*outerProxy.size.width, height: outerProxy.size.height/12.0, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitle("The Launcher")
    }
    
}
