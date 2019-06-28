//
//  UIColor+InitHelper.swift
//
//  Created by Mario Galijot on 27/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit.UIColor

public extension UIColor {
    
    /// Initializes a UIColor object with red, green and blue values,
    /// without the need for dividing the value (red, green or blue) with 255.0,
    /// because this function does that for you.
    ///
    /// - Parameters:
    ///   - r: Red value.
    ///   - g: Green value.
    ///   - b: Blue value.
    ///   - alpha: Alpha value of the color.
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
}
