//
//  UtilityFunctions.swift
//  Surf The Beat
//
//  Created by Samuel Donovan on 6/8/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import SwiftUI

func pow10<T: BinaryFloatingPoint>(exponent: Int) -> T {
    if exponent < 1 {fatalError()}
    if exponent == 1 {
        return 10.0
    } else {
        return 10.0*pow10(exponent: exponent - 1)
    }
}

func digitApproximator<T: BinaryFloatingPoint>(arg: T, digits: Int) -> String { // THIS IS PRETTY UGLY
    guard digits > 0 else {fatalError()}
    let isNegative = arg < 0.0
    let arg = abs(arg)
    let intComponent = Int(arg)
    let powered: T = pow10(exponent: digits)
    let decimalComponent = Int((arg - T(intComponent))*powered)
    return (isNegative ? "-" : "") + intComponent.description + "." + decimalComponent.description
}

func fontHelper() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
}

func toRadians<T: BinaryFloatingPoint>(degrees: T) -> T {degrees*(.pi/180.0)}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
