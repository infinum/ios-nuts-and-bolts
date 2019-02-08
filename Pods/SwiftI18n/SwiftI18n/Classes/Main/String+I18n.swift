//
//  String+I18n.swift
//  SwiftI18n
//
//  Created by Vlaho Poluta on 17/08/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

import UIKit

public extension String {
    
    public var localised: String {
        return I18nManager.instance[self]
    }
    
    public func  localisedFormat(with args: CVarArg...) -> String {
        return String(format: self.localised, args)
    }
    
}
