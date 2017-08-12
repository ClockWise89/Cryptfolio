//
//  ColorsExtension.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import UIKit

enum cfColor: String {
    case black = "#444444"
    case concrete = "#F3F3F3"
    case white = "#FDFDFD"
}

extension UIColor {
    
    fileprivate convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    fileprivate convenience init(cfColor: cfColor) {
        self.init(hexString: cfColor.rawValue)
    }
    
    static func randomColor() -> UIColor {
        let red = Float(arc4random()) /  Float(UInt32.max)
        let green = Float(arc4random()) /  Float(UInt32.max)
        let blue = Float(arc4random()) /  Float(UInt32.max)
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
    class func cfColor(_ cfColor: cfColor) -> UIColor {
        return UIColor(cfColor: cfColor)
    }
    
}
