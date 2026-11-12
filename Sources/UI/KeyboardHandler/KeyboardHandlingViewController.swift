//
//  KeyboardHandlingViewController.swift
//  Catalog
//
//  Created by Zvonimir Medak on 27.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import UIKit
import Combine

// This can be inside your project's BaseViewController
@available(iOS 13.0, *)
public class KeyboardHandlingViewController: UIViewController {

    // MARK: - Public properties -

    /// Return `true` if you want to receive keyboard appearance events
    var isKeyboardHandlingEnabled: Bool {
        return false
    }

    // MARK: - Private properties -

    private var keyboardCancellable: AnyCancellable?

    // MARK: - Keyboard handling -

    /// Called when Keyboard frame changes, eg. keyboard appears, disappears, resized etc. Must set `isKeyboardHandlingEnabled` to `true` beforehand to receive events
    /// - Parameter parameters: The Keyboard handler presenting events
    func keyboardPresentationChanged(with parameters: KeyboardHandler.PresentingParams) {}

}

// MARK: - Keyboard handling Helpers -

@available(iOS 13.0, *)
extension KeyboardHandlingViewController {

    /// Sets up the Keyboard handling, if enabled with `isKeyboardHandlingEnabled`
    private func setupKeyboardHandlingIfNeeded() {
        guard isKeyboardHandlingEnabled else { return }

        keyboardCancellable = KeyboardHandler.register(
            animatedHandler: { [unowned self] in keyboardPresentationChanged(with: $0) }
        )
    }

    /// Updates the content insets an indicator insets in the given `scrollView`.
    /// - Parameters:
    ///   - scrollView: The `UIScrollView` on which the content insets will be applied.
    ///   - parameters: The `KeyboardHandler.PresentingParams` data from which the keyboard state and height is retrieved.
    ///   - additionalInsets: Additional inset offset to be added to the scrollview `contentInset` depending on the keyboard state
    func handleKeyboardPresentation(
        scrollView: UIScrollView,
        parameters: KeyboardHandler.PresentingParams,
        additionalInsets: KeyboardHandler.Insets = .never
    ) {
        let height = additionalInsets.add(to: parameters.keyboardSize.height, with: parameters.state)
        scrollView.contentInset.bottom = height
        scrollView.verticalScrollIndicatorInsets.bottom = height
    }

    /// Updates the given constraint constant value to match the keyboard height + defaultMargin
    /// - Parameters:
    ///   - bottomConstraint: The `NSLayoutConstraint` where the `constant` will be updated. Usually the bottom constraint to the safe area
    ///   - defaultMargin: The default margin value when the keyboard is not visible and the margin between the keyboard and the pinned view
    ///   - parameters: The `KeyboardHandler.PresentingParams` data from which the keyboard state and height is retrieved.
    func handleKeyboardPresentation(bottomConstraint: NSLayoutConstraint, defaultMargin: CGFloat, parameters: KeyboardHandler.PresentingParams) {
        let keyboardOffset = max(parameters.keyboardSize.height - view.safeAreaInsets.bottom, 0)
        bottomConstraint.constant = defaultMargin + keyboardOffset
    }
}
