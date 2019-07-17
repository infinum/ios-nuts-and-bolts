//
//  UIView+Corners.swift
//
//  Created by Filip Gulan on 06/02/2019.
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
    
    /// Adds rounded corner edges to the view on specified coners with
    /// same radius for all of them.
    ///
    /// Be aware that this method uses layer for setting the mask
    /// so, probably you'll want to set layer.masksToBounds = true
    /// and use this from (did)layoutSubivews method since layer
    /// frame can change during the layout cycle.
    ///
    /// - Parameters:
    ///   - corners: Corners where to place round edge
    ///   - radius: Corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
