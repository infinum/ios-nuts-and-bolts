//
//  ClosedRange+Scalable.swift
//  Tests
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension ClosedRange where Bound: Scalable {
    
    /// From current interval scale given value to target interval
    ///
    /// Usage example:
    ///
    ///     let startInterval = CGFloat(0.0)...CGFloat(1.0)
    ///     let endInterval = CGFloat(0.0)...CGFloat(100.0)
    ///
    ///     let scaled = startInterval.scale(value: 0.5, toInterval: endInterval)
    ///     expect(scaled).to(equal(50))
    ///
    /// - Parameters:
    ///   - value: Value to scale
    ///   - toInterval: Target interval
    /// - Returns: Value scaled to target interval
    public func scale(value: Bound, toInterval: ClosedRange) -> Bound {
        
        func interpolate(_ value: Bound) -> Bound {
            return toInterval.lowerBound * (1.0 - value) + toInterval.upperBound * value
        }
        
        func uninterpolate(_ value: Bound) -> Bound {
            return (value - lowerBound) / (upperBound - lowerBound)
        }
        
        return interpolate(uninterpolate(value))
    }
    
}

public protocol Scalable: ExpressibleByFloatLiteral {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
}

extension Double: Scalable {}
extension Float: Scalable {}
extension CGFloat: Scalable {}

