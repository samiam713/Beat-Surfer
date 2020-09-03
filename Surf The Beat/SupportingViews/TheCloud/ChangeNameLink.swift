//
//  ChangeNameLink.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/20/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct ChangeNameLink: View {
    
    @ObservedObject var usernameLogic = UsernameLogic.singleton
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Text(usernameLogic.actualUsername)
                        .font(.title)
                        .bold()
                    Spacer()
                    Image("SurfIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100, maxHeight: 100, alignment: .center)
                }
            }
            Section {
                TextField("Change Username", text: $usernameLogic.potentialUsername)
                if usernameLogic.lastUNAttemptFailed {
                    Text("Username must be 3-15 characters and appropriate!")
                        .foregroundColor(.red)
                }
                Button.init("Attempt to Update Username", action: usernameLogic.attemptToSaveUsername)
            }
        }
        .navigationBarTitle("The Name")
        .onDisappear(perform: {
            self.usernameLogic.refreshUsernameChanging()
        })
    }
}
