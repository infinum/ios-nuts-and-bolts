//
//  CGSize+Extensions.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension CGSize {

    func adding(size: CGSize) -> CGSize {
        return CGSize(width: width + size.width, height: height + size.height)
    }

    func adding(insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width + insets.left + insets.right, height: height + insets.top + insets.bottom)
    }

    func substracting(insets: UIEdgeInsets) -> CGSize {
        return adding(insets: insets.inversed)
    }

    func scaled(factor: CGFloat) -> CGSize {
        applying(.init(scaleX: factor, y: factor))
    }

    /// Returns the larger constant between width and height
    var maxSide: CGFloat { max(width, height) }

    /// Returns the smaller constant between width and height
    var minSide: CGFloat { min(width, height) }
}

public extension CGSize {

    init(square: CGFloat) {
        self = CGSize(width: square, height: square)
    }

    static func square(_ constant: CGFloat) -> CGSize {
        return .init(square: constant)
    }
}
