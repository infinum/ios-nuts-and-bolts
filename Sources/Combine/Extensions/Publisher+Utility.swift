//
//  Publisher+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 28.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13, *)
public extension Publisher {

    /// Maps each sequence elements to given value.
    ///
    /// - Parameter value: Value to map
    /// - Returns: Sequence where all elements are given value.
    func mapTo<T>(_ value: T) -> Publishers.Map<Self, T> {
        return map { _ in value }
    }

    /// Maps each sequence element to Void type.
    ///
    /// - Returns: Sequence where all elements are of Void type.
    func mapToVoid() -> Publishers.Map<Self, Void> {
        return mapTo(())
    }
}
