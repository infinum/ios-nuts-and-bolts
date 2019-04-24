//
//  Bool+Logic.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// Function which allows you easier use of `AND` boolean logic in reduce functions, e.g. [true, true, false].reduce(true, Bool.and)
    ///
    /// - Parameters:
    ///   - lhs: First bool value
    ///   - rhs: Second bool value
    /// - Returns: result of applying `AND` operation to the provided params.
    static func and(lhs: Bool, rhs: Bool) -> Bool {
        return lhs && rhs
    }
    
    /// Function which allows you easier use of `OR` boolean logic in reduce functions, e.g. [true, true, false].reduce(true, Bool.or)
    ///
    /// - Parameters:
    ///   - lhs: First bool value
    ///   - rhs: Second bool value
    /// - Returns: result of applying `OR` operation to the provided params.
    static func or(lhs: Bool, rhs: Bool) -> Bool {
        return lhs || rhs
    }
    
    /// Function which allows you easier use of `XOR` boolean logic in reduce functions, e.g. [true, true, false].reduce(true, Bool.xor)
    ///
    /// - Parameters:
    ///   - lhs: First bool value
    ///   - rhs: Second bool value
    /// - Returns: result of applying `XOR` operation to the provided params.
    static func xor(lhs: Bool, rhs: Bool) -> Bool {
        switch (lhs, rhs) {
        case (false, false): return false
        case (false, true): return true
        case (true, false): return true
        case (true, true): return false
        }
    }
    
}
