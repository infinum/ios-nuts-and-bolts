//
//  RxUIMenu.swift
//  Catalog
//
//  Created by Sven Svetina on 14.03.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - RxUIMenu -

/// A container for grouping related menu elements in an app menu or contextual menu.
///
/// Create RxUIMenu wrapper around the UIMenu objects and use them to construct the menus and submenus your app displays.
/// Used in case where reactive action is needed.
@available(iOS 15.0, *)
class RxUIMenu<T> {

    let title: String
    let image: UIImage?
    let children: [RxUIAction<T>]

    /// Creates a new RxUIMenu with the specified values.
    ///
    /// - parameter title: The title of the menu.
    /// - parameter image: The image to display next to the menu’s title.
    /// - parameter children: The menu elements in the menu.
    init(title: String? = nil, image: UIImage? = nil, children: [RxUIAction<T>]) {
        self.title = title ?? ""
        self.image = image
        self.children = children
    }

    /// Creates UIMenu from RxUIMenu
    ///
    /// Should be used for assigning the `menu` value to the item (e.g. UIButton)
    func createUIMenu() -> UIMenu {
        return UIMenu(title: title, image: image, children: children.map(\.uiAction))
    }

    /// Selection signal
    ///
    /// Returns the value assigned to the `value` property in the `RxUIAction` child object.
    func selectedItem() -> Signal<T> {
        return Signal.merge(children.map { $0.asSignal() })
    }
}

// MARK: - RxUIAction -

/// A menu element that returns its performed action in a `Signal`.
@available(iOS 15.0, *)
class RxUIAction<T> {

    let title: String
    let subtitle: String?
    let image: UIImage?
    let attributes: UIMenuElement.Attributes
    let value: T

    private var didSelect: ((T) -> Void)?

    /// Creates an action with the specified title, subtitle, image, attributes, and value.
    ///
    /// - parameter title: The title to display for the action.
    /// - parameter subtitle: The subtitle to display alongside the action’s title.
    /// - parameter image: The image to display next to the action’s title.
    /// - parameter attributes: The attributes indicating the style of the action.
    /// - parameter value: Value returned in the `Signal` event.
    init(
        title: String,
        subtitle: String? = nil,
        image: UIImage? = nil,
        attributes: UIMenuElement.Attributes = [],
        value: T
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.attributes = attributes
        self.value = value
    }
}

// MARK: - RxUIAction Configuration -

@available(iOS 15.0, *)
private extension RxUIAction {

    var uiAction: UIAction {
        UIAction(title: title, subtitle: subtitle, image: image, attributes: attributes, handler: { [unowned self] _ in
            didSelect?(value)
        })
    }

    func asSignal() -> Signal<T> {
        return Observable.create { [unowned self] observer in
            didSelect = {
                observer.onNext($0)
            }
            return Disposables.create()
        }
        .asSignalOnErrorComplete()
    }
}

