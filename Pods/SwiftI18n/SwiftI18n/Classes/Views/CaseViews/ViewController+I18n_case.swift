//
//  ViewController+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

extension UIViewController: I18n {
    
    private static let case_titleKey = "CKEY"
    
    @IBInspectable public var caseTransform: String? {
    
        get {
            return loc_keysDictionary[UIViewController.case_titleKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UIViewController.case_titleKey] = newValue
            loc_localeDidChange()
        }
    }
    
    func loc_localeDidChange() {
        guard let title = loc_keysDictionary[UIViewController.loc_titleKey]?.localised else {
            self.title = nil
            return
        }
        
        let caseTransform = loc_keysDictionary[UIViewController.case_titleKey]
        self.title = title.transform(with: I18nCaseTransform(rawValue: caseTransform ?? ""))
    }
    
}
