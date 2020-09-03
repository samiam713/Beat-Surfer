//
//  MainMenuView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

func shagadelic(_ size: CGFloat = 24.0) -> Font {Font.custom("ShagadelicBold", size: size)}

let sandStart = Color(red: 1.0, green: 1.0, blue: 102.0/255.0)
let sandEnd = Color(red: 1.0, green: 1.0, blue: 204.0/255.0)

let grassStart = Color(red: 229.0/255.0, green: 1.0, blue: 204.0/255.0)
let grassEnd = Color(red: 204.0/255.0, green: 1.0, blue: 153.0/255.0)

let oceanBlue = Color(red: 180.0/255.0, green: 1.0, blue: 1.0)

func gradientMaker(top: Color, bottom: Color) -> LinearGradient {
    return LinearGradient(gradient: .init(colors: [top,bottom]), startPoint: .top, endPoint: .bottom)
}

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            GeometryReader {(proxy: GeometryProxy) in
                ZStack {
                    
                    // TAKE BACK ALL THIS BELOW:
                    // MAKE THE CONFIGURE BUTTON THE SUN IN SOME SEPARATE VIEW
                    // VSTACK {
                    // NEWLOGO, PICK SONG IN GREY BOUNDING BOX, HSTACK {READ MANUAL, MEET ARTIST}
                    // }
                    VStack {
                        Image("SDBLogoFullsize")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: proxy.size.width/50.0))
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        VStack {
                            NavigationLink(destination: SongSelectorView()) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                        .fill(gradientMaker(top: sandEnd, bottom: sandStart))
                                    Text("Select Song")
                                        .multilineTextAlignment(.center)
                                        .font(shagadelic())
                                        .foregroundColor(.black)
                                }
                                .frame(width: nil, height: proxy.size.height/12.0, alignment: .center)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                NavigationLink(destination: ManualView()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                            .fill(gradientMaker(top: sandEnd, bottom: sandStart))
                                        Text("Read Manual")
                                            .multilineTextAlignment(.center)
                                            .font(shagadelic())
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: nil, height: proxy.size.height/12.0, alignment: .center)
                                }
                                .buttonStyle(PlainButtonStyle())
                                NavigationLink(destination: HighScores()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: proxy.size.width/25.0)
                                            .fill(gradientMaker(top: sandEnd, bottom: sandStart))
                                        Text("High Scores")
                                            .multilineTextAlignment(.center)
                                            .font(shagadelic())
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: nil, height: proxy.size.height/12.0, alignment: .center)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                        .background(Rectangle().foregroundColor(oceanBlue))
                        .border(RadialGradient(gradient: .init(colors: [.black,.white]), center: .center, startRadius: 0.0, endRadius: proxy.size.width/2), width: 2.0)
                    }
                    ZStack {
                        NavigationLink(destination: ConfigurationView()) {
                            Circle().fill(RadialGradient(gradient: .init(colors: [.red,.yellow]), center: .center, startRadius: 0.0, endRadius: proxy.size.width*0.25))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Launch").font(shagadelic(42.0)).foregroundColor(.gray).offset(x: 0.0, y: 10.0)
                        
                    }
                    .frame(width: proxy.size.width*0.4, height: proxy.size.width*0.4, alignment: .center)
                    .position(x: proxy.size.width*0.7, y: proxy.size.width*0.3)
                }
            }
        .navigationBarTitle("The Main Menu")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

// each press
// (proportion of target note hit)*(proportion of time spent hitting target note)
// for tap notes: 
