//
//  UIView+ConstraintsSize.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    /// Creates and returns constraints that equate this view's width and/or height with some other view's.
    func constraintsWhichSize(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil) -> [NSLayoutConstraint] {
        return [
            height?.constraint(equalTo: heightAnchor),
            width?.constraint(equalTo: widthAnchor)
        ].compactMap { $0 }
    }

    /// Creates and returns a width-to-height constraint for this view. Greater than 1 is landscape, less than 1 is portrait.
    func constraintsWhichSize(aspectRatio: CGFloat) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        ]
    }

    /// Creates and returns a width-to-height constraint for this view, as well as a constant height constraint. Greater than 1 is landscape, less than 1 is portrait.
    func constraintsWhichSize(aspectRatio: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        ]
    }

    /// Creates and returns a width-to-height constraint for this view, as well as a constant width constraint. Greater than 1 is landscape, less than 1 is portrait.
    func constraintsWhichSize(aspectRatio: CGFloat, width: CGFloat) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio)
        ]
    }

    /// Creates and returns size constraints by specifying equal width and height constant.
    func constraintsWhichSize(square constant: CGFloat) -> [NSLayoutConstraint] {
        return constraintsWhichSize(aspectRatio: 1.0, height: constant)
    }

    /// Creates and returns size constraints by specifying equal width and height constant.
    func constraintsWhichSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }

}
