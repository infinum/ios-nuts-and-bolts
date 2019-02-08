//
//  UISearchBar+I18n_case.swift
//  Pods-SwiftI18n_Example
//
//  Created by Goran Brlas on 22/01/2019.
//

import UIKit

extension UISearchBar: I18n {
    
    private static let case_titleKey = "CKEY"
    private static let case_placeholderKey = "CPKEY"
    
    @IBInspectable public var caseTransform: String? {
        
        get {
            return loc_keysDictionary[UISearchBar.case_titleKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UISearchBar.case_titleKey] = newValue
            loc_localeDidChange()
        }
        
    }
    
    @IBInspectable public var casePlaceholderTransform: String? {
        
        get {
            return loc_keysDictionary[UISearchBar.case_placeholderKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UISearchBar.case_placeholderKey] = newValue
            loc_localeDidChange()
        }
        
    }
    
    func loc_localeDidChange() {
        let text = loc_keysDictionary[UISearchBar.loc_titleKey]?.localised
        let placeholder = loc_keysDictionary[UISearchBar.loc_placeholderKey]?.localised
        
        if let text = text {
            let caseTransform = loc_keysDictionary[UISearchBar.case_titleKey]
            self.text = text.transform(with: I18nCaseTransform(rawValue: caseTransform ?? ""))
        } else {
            self.text = nil
        }
        
        if let placeholder = placeholder {
            let casePlaceholderTransform = loc_keysDictionary[UISearchBar.case_placeholderKey]
            self.placeholder = placeholder.transform(with: I18nCaseTransform(rawValue: casePlaceholderTransform ?? ""))
        } else {
            self.placeholder = nil
        }
    }
    
}
