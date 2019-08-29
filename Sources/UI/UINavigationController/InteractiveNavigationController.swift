//
//  File.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 29/08/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//
//  Original implementation rewritten from AHKNavigationController
//  URL: https://github.com/fastred/AHKNavigationController

import UIKit

@objcMembers
class InteractiveNavigationController: UINavigationController {

    // MARK: - Private properties -

    private var duringPushAnimation = false
    private weak var realDelegate: UINavigationControllerDelegate?

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

}

// MARK: - UINavigationController -

extension InteractiveNavigationController {

    override var delegate: UINavigationControllerDelegate? {
        didSet {
            realDelegate = delegate === self ? nil : delegate
            super.delegate = delegate != nil ? self : nil
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate -

extension InteractiveNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        if interactivePopGestureRecognizer?.delegate !== self {
            assertionFailure("InteractiveNavigationController won't work correctly if you change interactivePopGestureRecognizer's delegate.")
            return
        }

        duringPushAnimation = false
        realDelegate?.navigationController?(navigationController, didShow: viewController, animated:animated)
    }
}

// MARK: - UIGestureRecognizerDelegate -

extension InteractiveNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != interactivePopGestureRecognizer {
            return true
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        let multipleViewControllers = viewControllers.count > 1
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        let animationNotInProgress = !duringPushAnimation
        // 3) when we weant to hide back button from our users to disabled navigation to previous screen
        let backButtonVisible = !(topViewController?.navigationItem.hidesBackButton ?? false)
        return multipleViewControllers && animationNotInProgress && backButtonVisible
    }
}

// MARK: - Delegate Forwarder -

extension InteractiveNavigationController {

    override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || realDelegate?.responds(to: aSelector) == true
    }

    override func forwardingTarget(for selector: Selector) -> Any? {
        if realDelegate?.responds(to: selector) == true {
            return realDelegate
        }
        return super.forwardingTarget(for: selector)
    }

}
