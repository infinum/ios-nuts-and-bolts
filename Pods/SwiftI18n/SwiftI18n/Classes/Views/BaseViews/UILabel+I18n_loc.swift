//
//  UILabel+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

public extension UILabel {
    
    static let loc_titleKey = "KEY"
    
    @IBInspectable public var locTitleKey: String? {
        
        get {
            return loc_keysDictionary[UILabel.loc_titleKey]
        }
        
        set(newValue) {
            loc_keysDictionary[UILabel.loc_titleKey] = newValue
            loc_localeDidChange()
        }
        
    }
    
}
