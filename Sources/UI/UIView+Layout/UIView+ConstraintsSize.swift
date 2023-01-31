//
//  UIView+ConstraintsSize.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    func constraintsWhichSize(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil) -> [NSLayoutConstraint] {
        return [
            height?.constraint(equalTo: heightAnchor),
            width?.constraint(equalTo: widthAnchor)
        ].compactMap { $0 }
    }

    func constraintsWhichSize(aspectRatio: CGFloat) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        ]
    }

    func constraintsWhichSize(aspectRatio: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        ]
    }

    func constraintsWhichSize(aspectRatio: CGFloat, width: CGFloat) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio)
        ]
    }

    func constraintsWhichSize(square constant: CGFloat) -> [NSLayoutConstraint] {
        return constraintsWhichSize(aspectRatio: 1.0, height: constant)
    }

    func constraintsWhichSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }

}
