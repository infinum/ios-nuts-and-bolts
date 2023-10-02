//
//  StackViewController.swift
//  Catalog
//
//  Created by Infinum on 31.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

/// A simple view controller with main stack view.
/// Builds upon CustomViewController with easy-to-override layout and constraints methods.
///
/// By default, the stack view is aligned with readable guides.
open class StackViewController: CustomViewController {

    open var mainStackView: UIStackView = .init(axis: .vertical, spacing: 16)

    open override var horizontalGuide: LayoutGuideKind {
        return .readableWidth
    }

    open override var verticalGuide: LayoutGuideKind {
        return .layoutMargin
    }

    override open func setupViewLayout() {
        super.setupViewLayout()
        view.addSubview(mainStackView)
    }

    override open func setupViewConstraints() -> [NSLayoutConstraint] {
        var constraints = super.setupViewConstraints()
        constraints += mainStackView.constraintWhichFitSuperview(
            horizontal: horizontalGuide,
            vertical: verticalGuide
        )
        return constraints
    }
}
