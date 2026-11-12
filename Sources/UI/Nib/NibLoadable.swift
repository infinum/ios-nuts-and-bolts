//
//  NibLoadable.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

/// An empty protocol so it is possible to explicitly tell which UIView will be loadable from nib.
/// (instead of making extension for all UIViews and exposing method for all UIViews including views that are not in separate nib/xib file)
public protocol NibLoadable: AnyObject { }

public extension NibLoadable where Self: UIView {

    /// Used to load the view from its respective .xib file.
    /// - Note: Use this to load a view which uses its custom class as the base class of the view. In cases that you're using `File's Owner`, please use `NibOwnerLoadable`.
    static func loadFromNib() -> Self {
        return Bundle.main.load(viewOfType: Self.self)
    }

    /// Used to load the nib of this respective view, from its .xib file.
    static func loadNib() -> UINib {
        let bundle = Bundle.main
        let viewName = String(describing: self)
        let nib = UINib(nibName: viewName, bundle: bundle)
        return nib
    }
}

/// A protocol for custom views made in xib that are meant to be reused through storyboards or in code.
public protocol NibOwnerLoadable: AnyObject {
    var contentView: UIView? { get set }
}

public extension NibOwnerLoadable where Self: UIView {

    /// Loads a nib for the provided name. It should be called from `init(coder:)` and/or `init(frame:)`
    /// - Parameters:
    ///     - xibName: Name of the nib that needs to be loaded.
    /// - Note: This allows us to construct nibs from either the storyboard or by using their init directly in code, provided that both inits are implemented.
    func loadNibContent(xibName: String? = nil) {
        guard let loadedContentView = loadViewFromNib(xibName) else { return }
        addSubview(loadedContentView)
        loadedContentView.pin(to: self)
        contentView = loadedContentView
    }

    private func loadViewFromNib(_ xibName: String?) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let xibName = xibName ?? String(describing: type(of: self))
        let nib = UINib(nibName: xibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
