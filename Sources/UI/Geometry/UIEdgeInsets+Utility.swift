//
//  UIEdgeInsets+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 27.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    /// Returns `UIEdgeInsets` with bottom inset only.
    static func bottom(inset: CGFloat) -> UIEdgeInsets {
        .init(top: 0, left: 0, bottom: inset, right: 0)
    }

    /// Returns `UIEdgeInsets` with top inset only.
    static func top(inset: CGFloat) -> UIEdgeInsets {
        .init(top: inset, left: 0, bottom: 0, right: 0)
    }

    /// Returns `UIEdgeInsets` with left inset only.
    static func left(inset: CGFloat) -> UIEdgeInsets {
        .init(top: 0, left: inset, bottom: 0, right: 0)
    }

    /// Returns `UIEdgeInsets` with right inset only.
    static func right(inset: CGFloat) -> UIEdgeInsets {
        .init(top: 0, left: 0, bottom: 0, right: inset)
    }

    /// Returns `UIEdgeInsets` with same vertical insets.
    static func vertical(inset: CGFloat) -> UIEdgeInsets {
        .init(top: inset, left: 0, bottom: inset, right: 0)
    }

    /// Returns `UIEdgeInsets` with vertical insets.
    static func vertical(top: CGFloat, bottom: CGFloat) -> UIEdgeInsets {
        .init(top: top, left: 0, bottom: bottom, right: 0)
    }

    /// Returns `UIEdgeInsets` with same horizontal insets.
    static func horizontal(inset: CGFloat) -> UIEdgeInsets {
        .init(top: 0, left: inset, bottom: 0, right: inset)
    }

    /// Returns `UIEdgeInsets` with horizontal insets.
    static func horizontal(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
        .init(top: 0, left: left, bottom: 0, right: right)
    }

    /// Returns symmetrical `UIEdgeInsets` with symmetrical horizontal and vertical insets.
    static func symmetrical(vertical: CGFloat, horizontal: CGFloat) -> UIEdgeInsets {
        .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    /// Returns `UIEdgeInsets` with the same spacing on all edges
    static func all(inset: CGFloat) -> UIEdgeInsets {
        .init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
