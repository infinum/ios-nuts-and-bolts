//
//  LayoutGuideInterface.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

/// A recrangular area, or a view that can interact with Auto Layout.
public protocol LayoutGuideInterface: AnyObject {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

// MARK: - Conformances: UILayoutGuide and UIView

/// UILayoutGuide conforms to LayoutGuideInterface - e.g. view.safeAreaLayoutGuides.leadingAnchor
extension UILayoutGuide: LayoutGuideInterface {}

/// UIView itself conforms to LayoutGuideInterface - e.g. view.leadingAnchor
extension UIView: LayoutGuideInterface {}

// MARK: - Extract guides from a UIView

extension LayoutGuideInterface where Self: UIView {

    /// Returns layout guide of specific kind (e.g. safe area guide)
    func layoutGuide(for kind: LayoutGuideKind) -> LayoutGuideInterface {
        switch kind {
        case .readableWidth: return readableContentGuide
        case .layoutMargin: return layoutMarginsGuide
        case .safeArea: return safeAreaLayoutGuide
        default: return self
        }
    }
}

// MARK: - Create Constraints

extension LayoutGuideInterface {

    /// Advanced Snap with horizontal and vertical guides separate. Returned constraints have to be activated.
    func createConstraintsAligningWithView(
        _ view: UIView,
        horizontal: LayoutGuideKind,
        vertical: LayoutGuideKind,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        let verticalGuide = view.layoutGuide(for: vertical)
        let horizontalGuide = view.layoutGuide(for: horizontal)
        return createConstraintsAligningWithAnchors(
            top: verticalGuide.topAnchor,
            bottom: verticalGuide.bottomAnchor,
            leading: horizontalGuide.leadingAnchor,
            trailing: horizontalGuide.trailingAnchor,
            insets: insets
        )
    }

    /// Simple Snap with all sides to same guide. Returned constraints have to be activated.
    func createConstraintsAligningWithGuide(
        _ layoutGuide: LayoutGuideInterface,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        return createConstraintsAligningWithAnchors(
            top: layoutGuide.topAnchor,
            bottom: layoutGuide.bottomAnchor,
            leading: layoutGuide.leadingAnchor,
            trailing: layoutGuide.trailingAnchor,
            insets: insets
        )
    }

    /// Individually snap this view/guide to specific anchors
    func createConstraintsAligningWithAnchors(
        top: NSLayoutYAxisAnchor?,
        bottom: NSLayoutYAxisAnchor?,
        leading: NSLayoutXAxisAnchor?,
        trailing: NSLayoutXAxisAnchor?,
        insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: insets.top))
        }
        if let bottom = bottom {
            constraints.append(bottom.constraint(equalTo: bottomAnchor, constant: insets.bottom))
        }
        if let leading = leading {
            constraints.append(leadingAnchor.constraint(equalTo: leading, constant: insets.left))
        }
        if let trailing = trailing {
            constraints.append(trailing.constraint(equalTo: trailingAnchor, constant: insets.right))
        }
        return constraints
    }
}
