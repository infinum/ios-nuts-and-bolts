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
final class RatioPresentationController: UIPresentationController {
    
    // MARK: - Public properties -
    
    /// Background color used for non-filled part of screen
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            _dimmingView.backgroundColor = backgroundColor
        }
    }
    
    /// Used screen ratio - fills the view controller
    public var ratio: CGFloat = 0.5
    
    /// Dismiss view controller when user taps on non-filled part
    public var shouldDismissOnTap: Bool = true
    
    // MARK: - Private properties -
    
    private lazy var _dimmingView: UIView = _createDimmingView()
    
    // MARK - Overrides -
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .none
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let size = self.size(forChildContentContainer: presentedViewController,
                             withParentContainerSize: _containerBounds.size)
        
        return CGRect(origin: CGPoint(x: 0.0, y: _containerFrame.maxY / 2), size: size)
    }
    
    override func size(
        forChildContentContainer container: UIContentContainer,
        withParentContainerSize parentSize: CGSize
    ) -> CGSize {
        return CGSize(width: parentSize.width, height: round(parentSize.height * ratio))
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        _dimmingView.frame = _containerBounds
        _dimmingView.alpha = 0.0
        containerView?.insertSubview(_dimmingView, at: 0)
        presentedView?.layer.masksToBounds = true
        
        let animations = {
            self._dimmingView.alpha = 1.0
            self.presentedView?.layer.cornerRadius = 16.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                animations()
            })
        } else {
            animations()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let animations = {
            self._dimmingView.alpha = 0.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        _dimmingView.frame = _containerBounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

}

private extension RatioPresentationController {
    
    var _containerBounds: CGRect {
        guard let containerView = containerView else {
            return presentingViewController.view.bounds
        }
        return containerView.bounds
    }
    
    var _containerFrame: CGRect {
        guard let containerView = containerView else {
            return presentingViewController.view.frame
        }
        return containerView.frame
    }
    
    func _createDimmingView() -> UIView {
        let view = UIView()
        
        view.backgroundColor = backgroundColor
        view.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(RatioPresentationController._dimmingViewTapped(_:)))
        view.addGestureRecognizer(tap)
        
        return view
    }
    
    @objc
    func _dimmingViewTapped(_ tap: UITapGestureRecognizer) {
        guard shouldDismissOnTap else {
            return
        }
        presentingViewController.dismiss(animated: true)
    }

}
