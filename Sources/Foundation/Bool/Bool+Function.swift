//
//  Bool+Function.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// Executes the provided function if self is `true`.
    ///
    /// - Parameter function: Function to execute
    func forTrue(do function: () -> ()) {
        if self { function() }
    }
    
    /// Executes the provided function if self is `false`.
    ///
    /// - Parameter function: Function to execute
    func forFalse(do function: () -> ()) {
        if !self { function() }
    }
    
}
