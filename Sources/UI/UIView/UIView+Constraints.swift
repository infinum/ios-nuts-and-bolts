//
//  UIView+Constraints.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Pins the current view edges to the superview with specified insets
    ///
    /// If current view doesn't have superview, then it is no-op.
    /// It uses left/top/right/bottom anchors when pinning view.
    /// Try to avoid leading/trailing anchors since they depend on locale
    ///
    /// - Parameters:
    ///   - view: Other view
    ///   - insets: View insets
    func pinToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        pin(to: superview, with: insets)
    }
    
    /// Pins the current view edges to the other view with specified insets
    ///
    /// It uses left/top/right/bottom anchors when pinning view.
    /// Try to avoid leading/trailing anchors since they depend on locale
    ///
    /// - Parameters:
    ///   - view: Other view
    ///   - insets: View insets
    func pin(to view: UIView, with insets: UIEdgeInsets = .zero) {
        pinTo(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            insets: insets
        )
    }
    
    /// Pins the current view edges to the specified edges with given insets
    ///
    /// It uses left/top/right/bottom anchors when pinning view.
    /// Try to avoid leading/trailing anchors since they depend on locale
    func pinTo(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        insets: UIEdgeInsets = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: insets.top))
        }
        if let left = left {
            constraints.append(leftAnchor.constraint(equalTo: left, constant: insets.top))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: insets.top))
        }
        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: right, constant: insets.top))
        }
        constraints.forEach { $0.isActive = true }
    }
    
}
