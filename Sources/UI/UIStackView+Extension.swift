//
//  UIStackView+Extension.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension UIStackView {

    /// Convenience initializer with most important parameters
    convenience init(
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0.0,
        margins: UIEdgeInsets? = nil,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
        if let margins = margins {
            isLayoutMarginsRelativeArrangement = true
            layoutMargins = margins
        }
    }
}

public extension UIStackView {

    /// Indicates whether this stack contains no subviews or it does but they're all hidden. Useful when deciding whether to hide the stack itself.
    var isEmptyOrAllSubviewsHidden: Bool {
        return arrangedSubviews.isEmpty || arrangedSubviews.allSatisfy(\.isHidden)
    }

    /// Adds specified view to the end of the arranged subviews array.
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }

    /// Adds specified view to the end of the arranged subviews array.
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    /// Removes all the existing views from the stack’s array of arranged subviews.
    func removeAllArrangedSubviews() {
        for subview in subviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    /// Removes provided views from the stack’s array of arranged subviews.
    func removeArrangedSubviews(_ views: [UIView]) {
        views.forEach { removeArrangedSubview($0) }
    }

    /// Removes all existing views and replaces them with this one new view (if provided).
    func replaceAllArrangedSubviews(with view: UIView?) {
        removeAllArrangedSubviews()
        if let view = view {
            addArrangedSubview(view)
        }
    }

    /// Adds padding. Sets up non-default layoutMargins and makes sure that 'isLayoutMarginsRelativeArrangement' is on.
    var explicitMargins: UIEdgeInsets? {
        get {
            if isLayoutMarginsRelativeArrangement {
                return layoutMargins
            } else {
                return nil
            }
        }
        set {
            if let newValue {
                isLayoutMarginsRelativeArrangement = true
                layoutMargins = newValue
            } else {
                isLayoutMarginsRelativeArrangement = false
                layoutMargins = .zero
            }

        }
    }
}
