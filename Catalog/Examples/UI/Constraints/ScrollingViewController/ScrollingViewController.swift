//
//  ScrollingViewController.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

/// A simple scroll view with a stack view inside that auto-sizes its content view.
/// Builds upon CustomViewController with easy-to-override layout and constraints methods.
open class ScrollingViewController: CustomViewController {

    open var scrollView: UIScrollView = .init(frame: .zero).autoLayoutable(preservesMargins: true)
    open var scrollContentView: UIView = .init(frame: .zero).autoLayoutable(preservesMargins: true)
    open var mainStackView: UIStackView = .init(axis: .vertical, spacing: 16)

    /// Padding between scroll view and main stack view's edges on top/bottom.
    var topAndBottomPadding: CGFloat {
        return 8.0
    }

    override open func setupViewLayout() {
        super.setupViewLayout()
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(mainStackView)
    }

    override open func setupViewConstraints() -> [NSLayoutConstraint] {
        var constraints = super.setupViewConstraints()
        constraints += scrollView.constraintsWhichFit(view)
        constraints += scrollContentView.constraintsWhichFit(scrollView.contentLayoutGuide)
        constraints += scrollContentView.constraintsWhichSize(width: scrollView.frameLayoutGuide.widthAnchor)
        constraints += mainStackView.constraintWhichFitSuperview(
            horizontal: horizontalGuide,
            vertical: .edge, // Can't use layout margins for vertical due to scroll view's automatic content insets.
            insets: .topAndBottom(topAndBottomPadding)
        )
        return constraints
    }
}
