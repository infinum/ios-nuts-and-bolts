//
//  UIView+LayerModifiers.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 17/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    /// Adds border color to the view. Should be used in combination with `borderWidth`.
    ///
    /// This modificator can be used in combination with `borderWidth` and `cornerRadius` modificators.
    /// `borderColor` could be set from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap(UIColor.init)
        }
        set (newColor) {
            layer.borderColor = newColor?.cgColor
        }
    }

    /// Adds border width to the view with color from `borderColor`.
    ///
    /// This modificator can be used in combination with `borderColor` and `cornerRadius` modificators.
    /// `borderWidth` could be set from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set (newBorderWidth) { layer.borderWidth = newBorderWidth }
    }

    /// Adds corner radius to all corners of the view.
    ///
    /// This modificator can be used in combination with `borderColor` and `borderWidth` modificators.
    /// `cornerRadius` could be set from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set (newCornerRadious) {
            layer.masksToBounds = true
            layer.cornerRadius = newCornerRadious
        }
    }

}
