//
//  UIView+Constraints.swift
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension UIView {
    
    // MARK: - Pin edges -
    
    /// Pins the current view edges to the superview with specified insets
    ///
    /// If current view doesn't have superview, then it is no-op.
    /// It uses left/top/right/bottom anchors when pinning view.
    /// Try to avoid leading/trailing anchors since they depend on locale
    ///
    /// - Parameters:
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
            constraints.append(leftAnchor.constraint(equalTo: left, constant: insets.left))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: insets.bottom))
        }
        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: right, constant: insets.right))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Pins the current view to the specified size
    ///
    /// - Parameters:
    ///   - size: Pin size
    func pin(to size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(widthAnchor.constraint(equalToConstant: size.width))
        constraints.append(heightAnchor.constraint(equalToConstant: size.height))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Pins the current view width and/or height to specified dimensions
    ///
    /// - Parameters:
    ///   - width: Pin width
    ///   - height: Pin height
    func pinTo(
        width: NSLayoutDimension? = nil,
        height: NSLayoutDimension? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if let height = height {
            constraints.append(heightAnchor.constraint(equalTo: height, multiplier: 1.0))
        }
        if let width = width {
            constraints.append(widthAnchor.constraint(equalTo: width, multiplier: 1.0))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Center
    
    /// Center the current view to the center of superview with specified insets
    ///
    /// - Parameters:
    ///   - insets: Center insets
    func centerToSuperview(insets: CGPoint = .zero) {
        guard let superview = superview else { return }
        center(to: superview, with: insets)
    }
    
    /// Center the current view to the center of view with specified insets
    ///
    /// - Parameters:
    ///   - view: Other view
    ///   - insets: Center insets
    func center(to view: UIView, with insets: CGPoint = .zero) {
        centerTo(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            insets: insets
        )
    }
    
    /// Centers the current view to the specified centers with given insets
    func centerTo(
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        insets: CGPoint = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if let centerX = centerX {
            constraints.append(centerXAnchor.constraint(equalTo: centerX, constant: insets.x))
        }
        if let centerY = centerY {
            constraints.append(centerYAnchor.constraint(equalTo: centerY, constant: insets.y))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
}
