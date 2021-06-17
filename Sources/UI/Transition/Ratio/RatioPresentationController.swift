//
//  RatioPresentationController.swift
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
public final class RatioPresentationController: UIPresentationController {
    
    public enum TransitionType {
        case present, dismiss
    }
    
    // MARK: - Public properties -
    
    /// Background color used for non-filled part of screen
    public var backgroundColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            dimmingView.backgroundColor = backgroundColor
        }
    }
    
    /// Used screen ratio - fills the view controller
    public var ratio: CGFloat = 0.5
    
    /// Dismiss view controller when user taps on non-filled part
    public var shouldDismissOnTap = true
    
    /// Ability to customize animations on `presentedView` in
    /// present and dismiss transition
    /// **Please, use weak reference to self inside animation**
    public var animations: ((_ presentedView: UIView?, _ transition: TransitionType) -> Void)?
    
    // MARK: - Private properties -
    
    private lazy var dimmingView: UIView = createDimmingView()
    
    // MARK: - Overrides -
    
    override public var adaptivePresentationStyle: UIModalPresentationStyle {
        return .none
    }
    
    override public var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        let size = self.size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerBounds.size
        )

        let yPos = containerFrame.maxY - size.height
        let origin = CGPoint(x: 0.0, y: yPos)
        return CGRect(origin: origin, size: size)
    }
    
    override public func size(
        forChildContentContainer container: UIContentContainer,
        withParentContainerSize parentSize: CGSize
    ) -> CGSize {
        return CGSize(width: parentSize.width, height: round(parentSize.height * ratio))
    }

    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        dimmingView.frame = containerBounds
        dimmingView.alpha = 0.0
        containerView?.insertSubview(dimmingView, at: 0)
        
        let animations = { [weak self] in
            guard let self = self else { return }
            self.dimmingView.alpha = 1.0
            self.animations?(self.presentedView, .present)
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                animations()
            })
        } else {
            animations()
        }
    }
    
    override public func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let animations = { [weak self] in
            guard let self = self else { return }
            self.dimmingView.alpha = 0.0
            self.animations?(self.presentedView, .dismiss)
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(
                alongsideTransition: { _ in
                    animations()
                },
                completion: nil
            )
        } else {
            animations()
        }
    }
    
    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerBounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

}

private extension RatioPresentationController {
    
    var containerBounds: CGRect {
        guard let containerView = containerView else {
            return presentingViewController.view.bounds
        }
        return containerView.bounds
    }
    
    var containerFrame: CGRect {
        guard let containerView = containerView else {
            return presentingViewController.view.frame
        }
        return containerView.frame
    }
    
    func createDimmingView() -> UIView {
        let view = UIView()
        
        view.backgroundColor = backgroundColor
        view.alpha = 0.0
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(RatioPresentationController.dimmingViewTapped(_:))
        )
        view.addGestureRecognizer(tap)
        
        return view
    }
    
    @objc
    func dimmingViewTapped(_ tap: UITapGestureRecognizer) {
        guard shouldDismissOnTap else {
            return
        }
        presentingViewController.dismiss(animated: true)
    }

}
