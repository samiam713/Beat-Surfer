//
//  SelectionScreen.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

func makeSettingsSheet(arView2: ARView2) -> ActionSheet {
    ActionSheet(title: Text("Settings"), message: nil, buttons: [
        .default(Text("Read the Manual"), action: {arView2.presentSheet(type: .manual)}),
        .default(Text("Place Again"), action: arView2.placeAgain),
        .destructive(Text("Main Menu"), action: arView2.toMainMenu),
        .cancel(arView2.unshowSettings)
    ])
}

