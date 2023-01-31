//
//  UIView+ConstraintsFitPin.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

// MARK: - Create and return constraints

public extension UIView {

    /// Aligns (pins) sides with given view or layout guide. Returned constraints have to be activated.
    func constraintsWhichFit(_ viewOrLayoutGuide: LayoutGuideInterface, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return createConstraintsAligningWithGuide(viewOrLayoutGuide, insets: insets)
    }

    // MARK: Advanced - separate leftRight vs topBottom guides:

    /// Creates and returns constraints that align (pins) sides with given view or layout guide according to vertical (top/bottom) and horizontal (leading/trailing) guide. Returned constraints have to be activated.
    ///
    /// For example, to fit your stack view to readable guides on side and to safe area on top/bottom, you would:
    /// ```swift
    /// let constraints = stackView.constraintsWhich(
    ///     fit: view,
    ///     horizontal: .readableWidth,
    ///     vertical: .safeArea
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - fit: Other view
    ///   - horizontal: leading and trailing constraints guide
    ///   - vertical: top and bottom constraints guide
    ///   - insets: View insets
    func constraintsWhichFit(
        _ view: UIView,
        horizontal: LayoutGuideKind,
        vertical: LayoutGuideKind,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        return createConstraintsAligningWithView(view, horizontal: horizontal, vertical: vertical, insets: insets)
    }

    // MARK: - Pin To

    /// Creates and returns constraints that align view edges to the specified anchors with given insets. Returned constraints have to be activated.
    /// - Parameters:
    ///   - top: Top Anchor
    ///   - bottom: Bottom Anchor
    ///   - leading: Leading Anchor
    ///   - trailing: Trailing Anchor
    ///   - insets: View insets
    func constraintsWhichPin(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        return createConstraintsAligningWithAnchors(
            top: top,
            bottom: bottom,
            leading: leading,
            trailing: trailing,
            insets: insets
        )
    }

    func constraintWhichFitSuperview(
        horizontal: LayoutGuideKind = .edge,
        vertical: LayoutGuideKind = .edge,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let superview else { return [] }
        return constraintsWhichFit(superview, horizontal: horizontal, vertical: vertical, insets: insets)
    }
}
