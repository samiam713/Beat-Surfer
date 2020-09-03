//
//  VictoryView.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 5/17/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct SocialSharer: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    init(activityItems: [Any]) {
        self.activityItems = activityItems
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}
