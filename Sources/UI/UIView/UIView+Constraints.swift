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
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        ])
    }
    
}
