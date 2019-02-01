//
//  UITextField+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

extension UITextField: I18n {
    
    private static let case_titleKey = "CKEY"
    private static let case_placeholderKey = "CPKEY"
    
    @IBInspectable public var caseTransform: String? {
    
        get {
            return loc_keysDictionary[UITextField.case_titleKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UITextField.case_titleKey] = newValue
            loc_localeDidChange()
        }
    }
    
    @IBInspectable public var casePlaceholderTransform: String? {
    
        get {
            return loc_keysDictionary[UITextField.case_placeholderKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UITextField.case_placeholderKey] = newValue
            loc_localeDidChange()
        }
    }
    
    func loc_localeDidChange() {
        let text = loc_keysDictionary[UITextField.loc_titleKey]?.localised
        let placeholder = loc_keysDictionary[UITextField.loc_placeholderKey]?.localised
        
        if let text = text {
            let caseTransform = loc_keysDictionary[UITextField.case_titleKey]
            self.text = text.transform(with: I18nCaseTransform(rawValue: caseTransform ?? ""))
        } else {
            self.text = nil
        }
        
        if let placeholder = placeholder {
            let casePlaceholderTransform = loc_keysDictionary[UITextField.case_placeholderKey]
            self.placeholder = placeholder.transform(with: I18nCaseTransform(rawValue: casePlaceholderTransform ?? ""))
        } else {
            self.placeholder = nil
        }
        
    }
    
}
