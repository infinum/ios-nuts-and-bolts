//
//  RatioPresentationManager.swift
//
//  Created by Filip Gulan on 25/10/2018.
//  Copyright © 2018 Infinum. All rights reserved.
//

import UIKit

/// Displays current view controller over parent controller with sepcified
/// `ratio`.
///
/// Non-filled part color can be controlled with `backgroundColor` property.
///
/// Dismiss handling can be controlled via `shouldDismissOnTap` property.
///
/// Idea from https://jessesquires.github.io/PresenterKit
public final class RatioPresentationManager: NSObject {
    
    /// Used screen ratio - fills the view controller
    public var ratio: CGFloat = 0.5
    
    /// Background color used for non-filled part of screen
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)

    /// Dismiss view controller when user taps on non-filled part
    public var shouldDismissOnTap: Bool = true
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension RatioPresentationManager: UIViewControllerTransitioningDelegate {
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = RatioPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        presentationController.ratio = ratio
        presentationController.backgroundColor = backgroundColor
        presentationController.shouldDismissOnTap = shouldDismissOnTap
        return presentationController
    }
    
}
