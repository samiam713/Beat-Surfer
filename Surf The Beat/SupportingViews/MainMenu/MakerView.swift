//
//  MakerView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/12/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct MakerView: View {
    let url = URL(string: "https://samdonovan.com/")!
    var body: some View {
        VStack {
            Button.init("Website") {
                UIApplication.shared.open(self.url)
            }
        }
        .navigationBarTitle("The Makers")
    }
}

struct MakerView_Previews: PreviewProvider {
    static var previews: some View {
        MakerView()
    }
}
