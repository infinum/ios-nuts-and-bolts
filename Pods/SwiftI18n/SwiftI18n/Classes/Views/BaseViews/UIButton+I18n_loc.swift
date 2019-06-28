//
//  UIButton+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

extension UIControl.State: Hashable {
    
    public var hashValue: Int {
        return Int(self.rawValue)
    }
    
}

public extension UIButton {
    
    @IBInspectable var locTitleKey: String? {
        get {
            return locTitleKey(for: .normal)
        }
        
        set(newValue) {
            loc_allStates.forEach { setLocTitleKey(newValue, for: $0) }
            loc_localeDidChange()
        }
    }
    
    func setLocTitleKey(_ key: String?, `for` state: UIControl.State) {
        loc_keysDictionary[state] = key
    }
    
    func locTitleKey(`for` state: UIControl.State) -> String? {
        return loc_keysDictionary[state]
    }
    
    var loc_allStates: [UIControl.State] {
        return [.normal, .disabled, .highlighted, .selected]
    }
    
}

