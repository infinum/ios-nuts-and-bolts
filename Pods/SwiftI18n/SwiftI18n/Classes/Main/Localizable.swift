//
//  I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/04/18.
//  Copyright © 2016 Infinum. All rights reserved.
//

import Foundation

public struct Localizable<Base: LocKeyAcceptable> {
    public var base: Base
}

public protocol LocKeyAcceptable: class {
    var locTitleKey: String? { get set }
}

public extension LocKeyAcceptable {
    var loc: Localizable<Self> {
        get { return Localizable(base: self) }
        set { }
    }
}

extension UIBarButtonItem: LocKeyAcceptable {}
extension UILabel: LocKeyAcceptable {}
extension UINavigationItem: LocKeyAcceptable {}
extension UITabBarItem: LocKeyAcceptable {}
extension UITextView: LocKeyAcceptable {}
extension UIButton: LocKeyAcceptable {}
extension UITextField: LocKeyAcceptable {}
extension UIViewController: LocKeyAcceptable {}
extension UISearchBar: LocKeyAcceptable {}
