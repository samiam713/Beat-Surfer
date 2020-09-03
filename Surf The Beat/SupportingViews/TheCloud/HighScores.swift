//
//  HighScores.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/20/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct HighScores: View {
    
    
    
    var body: some View {
        // basically a navigation link parent for files below (select genre/song then view HS OR select changeName)
        VStack {
            NavigationLink(destination: ChangeNameLink(), label: {
                Text("Change Username")
            })
            Text("PICKER HERE")
            Text("LIST OF SONGS HERE")
        }
    .navigationBarTitle("The Scores")
        
    }
}

