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

    var isEmptyOrAllSubviewsHidden: Bool {
        return arrangedSubviews.isEmpty || arrangedSubviews.allSatisfy(\.isHidden)
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }

    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    func removeAllArrangedSubviews() {
        for subview in subviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    func removeArrangedSubviews(_ views: [UIView]) {
        views.forEach { removeArrangedSubview($0) }
    }

    func replaceAllArrangedSubviews(with view: UIView?) {
        removeAllArrangedSubviews()
        if let view = view {
            addArrangedSubview(view)
        }
    }

    /// Adds padding. Sets up non-default layoutMargins and makes sure that 'isLayoutMarginsRelativeArrangement' is on.
    var explicitMargins: UIEdgeInsets? {
        get {
            return isLayoutMarginsRelativeArrangement ? nil : layoutMargins
        }
        set {
            isLayoutMarginsRelativeArrangement = newValue != nil
            layoutMargins = newValue ?? .zero
        }
    }
}
