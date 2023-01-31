//
//  UIEdgeInsets.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

// MARK: - Initialization

public extension UIEdgeInsets {

    /// Initializes and returns edge insets with all the constants of equal value.
    static func allEqual(_ const: CGFloat) -> UIEdgeInsets { return .init(top: const, left: const, bottom: const, right: const) }

    /// Initializes and returns edge insets with equal top and bottom constants, zero for others.
    static func topAndBottom(_ const: CGFloat) -> UIEdgeInsets { return .onlyAt(top: const, bottom: const) }

    /// Initializes and returns edge insets with equal left and right constants, zero for others.
    static func leftAndRight(_ const: CGFloat) -> UIEdgeInsets { return .onlyAt(left: const, right: const) }

    /// Initializes and returns edge insets with different but symmetrical horizontal/vertical constants.
    init(leftRight: CGFloat = 0.0, topBottom: CGFloat) {
        self.init(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }

    /// Initializes and returns edge insets with only some non-zero constants.
    static func onlyAt(top: CGFloat = 0.0, left: CGFloat = 0.0, bottom: CGFloat = 0.0, right: CGFloat = 0.0) -> Self {
        return Self(top: top, left: left, bottom: bottom, right: right)
    }
}

// MARK: - Calculated Properties

public extension UIEdgeInsets {

    /// Sum of horizontal edge insets
    var leftAndRight: CGFloat { self.left + self.right }

    /// Sum of vertical edge insets
    var topAndBottom: CGFloat { self.top + self.bottom }

    /// Returns edge insets with all constants inversed (multiplied by -1)
    var inversed: UIEdgeInsets {
        return .init(top: -top, left: -self.left, bottom: -bottom, right: -self.right)
    }
}
