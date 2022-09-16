//
//  UIView+HiddenExtensions.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

// MARK: - Hiding and showing

public extension UIView {

    func hide() {
        guard !isHidden else { return }
        isHidden = true
    }

    func show() {
        guard isHidden else { return }
        isHidden = false
    }
}

// MARK: - Show & hide within stack view

public extension UIView {

    /// Safely hides the view if it's within a UIStackView.
    ///
    /// UIStackView has a bug. If you set isHidden of a subview to the same value multiple times, you have to
    /// set it the same number of times to toggle the hidden property.
    ///
    /// ex. if you set isHidden to false 3 times, you have to set it to true 3 times to show it.
    ///
    /// - Note: https://stackoverflow.com/a/45599835/9753141
    var isHiddenInStackView: Bool {
        get { isHidden }
        set { setHiddenInStackView(newValue) }
    }

    private func setHiddenInStackView(_ hidden: Bool) {
        if hidden {
            hide()
        } else {
            show()
        }
    }
}

// MARK: - Animated hide

public extension UIView {

    var isHiddenAnimated: Bool {
        get { isHidden }
        set { isHiddenAnimated(isHidden: newValue, duration: 0.2) }
    }

    func isHiddenAnimated(isHidden: Bool, duration: TimeInterval) {
        // Unhide the view first to actually see the alpha animation, otherwise the view will just end up popping up once the
        // animation block finishes.
        if self.isHidden { self.isHidden.toggle() }

        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: duration) {
            self.alpha = isHidden ? 0 : 1
        } completion: { completed in
            // Similar to the above case, but in this instance we want to adjust hidden property only once the alpha animation ends.
            self.isHidden = isHidden && completed
        }
    }
}
