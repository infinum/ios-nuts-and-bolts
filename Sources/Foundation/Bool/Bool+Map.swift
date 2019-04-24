//
//  Bool+Map.swift
//  Catalog
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// If the bool is `true` the provided object is returned, otherwise `nil` is returned.
    ///
    /// - Parameter object: Object to be returned if the bool is `true`.
    /// - Returns: `object` if `true`, `nil` otherwise.
    func mapTrue<T>(to object: T) -> T? {
        return self ? object : nil
    }
    
    /// If the bool is `false` the provided object is returned, otherwise `nil` is returned.
    ///
    /// - Parameter object: Object to be returned if the bool is `false`.
    /// - Returns: `object` if `false`, `nil` otherwise.
    func mapFalse<T>(to object: T) -> T? {
        return self ? nil : object
    }
    
    /// If the bool is `true` the provided optional object is returned, otherwise `nil` is returned.
    ///
    /// - Parameter object: Optional object to be returned if the bool is `true`.
    /// - Returns: `object` if `true`, `nil` otherwise.
    func mapTrue<T>(for object: T?) -> T? {
        return self ? object : nil
    }
    
    /// If the bool is `false` the provided optional object is returned, otherwise `nil` is returned.
    ///
    /// - Parameter object: Optional object to be returned if the bool is `false`.
    /// - Returns: `object` if `false`, `nil` otherwise.
    func mapFalse<T>(for object: T?) -> T? {
        return self ? nil : object
    }
    
    /// If the bool is `true`, `mapping` is applied to the provided `object` and its result is returned, otherwise `nil` is returned.
    ///
    /// - Parameters:
    ///   - object: Optional object to be returned if the bool is `true`.
    ///   - mapping: Function to be applied on the `object` parameter.
    /// - Returns: Result of applying `mapping` on `object` if `true`, `nil` otherwise.
    func mapTrue<T, U>(for object: T?, _ mapping: (T) -> (U)) -> U? {
        return self ? object.flatMap(mapping) : nil
    }

    /// If the bool is `false`, `mapping` is applied to the provided `object` and its result is returned, otherwise `nil` is returned.
    /// - Parameters:
    ///   - object: Optional object to be returned if the bool is `false`.
    ///   - mapping: Function to be applied on the `object` parameter.
    /// - Returns: Result of applying `mapping` on `object` if `false`, `nil` otherwise.
    func mapFalse<T, U>(for object: T?, _ mapping: (T) -> (U)) -> U? {
        return self ? nil : object.flatMap(mapping)
    }
    
}
