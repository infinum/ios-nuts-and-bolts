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
