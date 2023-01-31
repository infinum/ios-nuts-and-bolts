//
//  UIView+Corners.swift
//
//  Created by Filip Gulan on 06/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension UIView {
    
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
    func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat, isContinuous: Bool = false) {
        var maskedCorners: CACornerMask = []
        if corners.contains(.topLeft) { maskedCorners.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { maskedCorners.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { maskedCorners.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { maskedCorners.insert(.layerMaxXMaxYCorner) }
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
        if #available(iOS 13.0, *) {
            layer.cornerCurve = isContinuous ? .continuous : .circular
        }
    }

    /// Applies rounded corners so that the view appears as a pill (or a circle if square shaped).
    func roundCornersAsPill() {
        cornerRadius = bounds.size.minSide / 2
    }

    /// Applies rounded corners so that the view appears as circle. Warning: frame must be square.
    func roundCornersAsCircle() {
        cornerRadius = bounds.size.maxSide / 2
    }

}
