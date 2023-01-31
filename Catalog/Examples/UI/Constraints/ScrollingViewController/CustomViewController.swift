//
//  CustomViewController.swift
//  Catalog
//
//  Created by Infinum on 31.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

/// A view controller with simple-to-override layout and constraint creation/activation methods.
///
/// Has a few other overrideable properties like horizontal/vertical guides and default presentation style.
open class CustomViewController: UIViewController {

    open var horizontalGuide: LayoutGuideKind {
        return .layoutMargin
    }

    open var verticalGuide: LayoutGuideKind {
        return .layoutMargin
    }

    var defaultPresentationStyle: UIModalPresentationStyle? {
        return nil // Override to have default style of presentation
    }

    // MARK: - Initialization

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupAfterInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAfterInit()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayoutAndConstraints()
    }

    // MARK: - Setup Layout and Constraints

    open func setupAfterInit() {
        if let style = defaultPresentationStyle {
            modalPresentationStyle = style
        }
    }

    private func setupViewLayoutAndConstraints() {
        setupViewLayout()
        let constraints = setupViewConstraints()
        if !constraints.isEmpty {
            NSLayoutConstraint.activate(constraints)
        }
    }

    /// Add your subviews and set up hierarchy here, before creating constraints.
    open func setupViewLayout() {
        // Override in subclass
    }

    /// Create and return constraints for subviews here. Make sure to append to super's constraints.
    open func setupViewConstraints() -> [NSLayoutConstraint] {
        return [] // Override in subclass
    }
}
