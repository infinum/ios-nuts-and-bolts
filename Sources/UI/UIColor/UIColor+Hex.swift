//
//  UIColor+Hex.swift
//
//  Created by Mario Galijot on 27/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit.UIColor

public extension UIColor {
    
    /// Initializes a UIColor object with a Hex string.
    /// A Hex string can be either 6 characters long (a Hex string without alpha channel),
    /// or it can be 8 characters long (a Hex string with defined alpha channel),
    /// You can pass '#' or you can omit it, however, this function will remove it.
    ///
    /// - Parameter hex: Hex color string, from which a UIColor object will be created.
    convenience init(hex: String) {
        let hexSanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var color: UInt32 = 0
        Scanner(string: hexSanitized).scanHexInt32(&color)
        
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
        
        if hexSanitized.count == 6 {
            red = CGFloat((color & 0xFF0000) >> 16) / 255.0
            green = CGFloat((color & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(color & 0x0000FF) / 255.0
            alpha = 1
        } else if hexSanitized.count == 8 {
            red = CGFloat((color & 0xFF000000) >> 24) / 255.0
            green = CGFloat((color & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((color & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(color & 0x000000FF) / 255.0
        } else {
            assertionFailure("You have entered a non-valid hex color string. Please, check your input.")
            self.init(r: 0, g: 0, b: 0)
            return
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Generates a Hex string, from a current color value.
    ///
    /// - Parameter includeAlpha: Boolean value indicating whether the alpha channel should be included in a hex string. Default is false.
    /// - Returns: Hex color string, generated from a current color value.
    func getHex(withAlpha includeAlpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        let alpha = Float(components.count >= 4 ? components[3] : 1)
        
        if includeAlpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255), lroundf(alpha * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        }
    }
}
