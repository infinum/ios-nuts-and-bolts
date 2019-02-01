//
//  I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/04/18.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

public protocol I18nCaseTransformable {
    var caseTransform: String? { get set }
}

public extension Localizable where Base: I18nCaseTransformable {
    var caseTransform: I18nCaseTransform? {
        get { return base.caseTransform.flatMap { I18nCaseTransform(rawValue: $0) } }
        set { base.caseTransform = newValue?.rawValue }
    }
}

extension UIBarButtonItem: I18nCaseTransformable {}
extension UILabel: I18nCaseTransformable {}
extension UINavigationItem: I18nCaseTransformable {}
extension UITabBarItem: I18nCaseTransformable {}
extension UITextView: I18nCaseTransformable {}
extension UIButton: I18nCaseTransformable {}
extension UITextField: I18nCaseTransformable {}
extension UIViewController: I18nCaseTransformable {}
extension UISearchBar: I18nCaseTransformable {}

public extension Localizable where Base: UIButton {
 
    func setCaseTransform(_ key: I18nCaseTransform?, `for` state: UIControl.State) {
        base.setCaseTransform(key, for: state)
    }
    
    func caseTransform(`for` state: UIControl.State) -> I18nCaseTransform? {
        return base.caseTransform(for: state)
    }
    
}

public extension Localizable where Base: UITextField {
    var caseTransformPlaceholder: I18nCaseTransform? {
        get { return base.casePlaceholderTransform.flatMap { I18nCaseTransform(rawValue: $0) } }
        set { base.casePlaceholderTransform = newValue?.rawValue }
    }
}
