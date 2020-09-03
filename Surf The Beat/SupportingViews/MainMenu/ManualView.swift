//
//  ManualView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/17/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct ManualView: View {
    
    let instructions = [
        "Pick a song (or do it later)",
        "Configure the size of the VirtualInstrument™",
        "Scan some sort of horizontal surface (e.g. a tabletop)",
        "If the surface is recognized, you can place the VirtualInstrument™",
        "Configure the VirtualInstrument™ and song (if necessary)",
        "Press play to start the game",
        "Tap the VirtualInstrument™ buttons at the correct times",
        "Tap spheres quickly and hold on cylinders",
        "Load a song into the VirtualInstrument™ to start over",
        "Have fun I guess"
    ]
    
    var body: some View {
        
        List(instructions.indices, rowContent: {index in
            HStack {
                Text("\(index)) ")
                Text(self.instructions[index]).italic()
            }
        })
        .navigationBarTitle("The Manual")
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
