//
//  I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

protocol I18n: class {
    func loc_localeDidChange()
}

private struct AssociatedKeys {
    static var keysDictionary = "loc_keysDictionary"
    static var disposable = "loc_disposable"
}

extension I18n {
    
    var loc_keysDictionary: KeysDictionary {
        if let keysDictionary = objc_getAssociatedObject(self, &AssociatedKeys.keysDictionary) as? KeysDictionary {
            return keysDictionary
        }
        let keysDictionary = KeysDictionary()
        objc_setAssociatedObject(self, &AssociatedKeys.keysDictionary, keysDictionary, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let observable = I18nManager.subscribeForLocaleDidChange { [weak self] in self?.loc_localeDidChange() }
        let disposable = LocDisposable { NotificationCenter.default.removeObserver(observable) }
        objc_setAssociatedObject(self, &AssociatedKeys.disposable, disposable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return keysDictionary
    }
}

class KeysDictionary {
    
    var dictionary = [AnyHashable: String]()
    
    subscript(key: AnyHashable) -> String? {
        get {
            return dictionary[key]
        }
        
        set(newValue) {
            dictionary[key] = newValue
        }
    }
    
}

fileprivate class LocDisposable {
    
    let block: ()->()
    
    init(block: @escaping ()->()) {
        self.block = block
    }
    
    deinit {
        block()
    }
}
