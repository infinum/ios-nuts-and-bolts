//
//  ViewController+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    static let loc_titleKey = "KEY"
    
    @IBInspectable var locTitleKey: String? {
        get {
            return loc_keysDictionary[UIViewController.loc_titleKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UIViewController.loc_titleKey] = newValue
            loc_localeDidChange()
        }
    }
    
}
