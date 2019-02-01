//
//  String+Blank.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension String {
    
    /// Checks if string is empty or contains only whitespaces and newlines
    ///
    /// Returns `true` if string is empty or contains only whitespaces and newlines
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

public extension Optional where Wrapped == String {
    
    /// Helper to check if string is nil or empty
    ///
    /// Returns `true` if string is nil, empty or contains only whitespaces and newlines
    var isBlank: Bool {
        if let unwrapped = self {
            return unwrapped.isBlank
        } else {
            return true
        }
    }
    
}
