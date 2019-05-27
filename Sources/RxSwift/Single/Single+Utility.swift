//
//  Single+Utility.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Single {
    
    /// Converts current Single sequence to Driver, completing on error event.
    ///
    /// - Returns: Driver - completing on error event
    func asDriverOnErrorComplete() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    
    /// Maps sequence element to given value.
    ///
    /// - Parameter value: Value to map
    /// - Returns: Sequence where element is given value.
    func mapTo<T>(_ value: T) -> Single<T> {
        return map { _ in value }
    }
    
    /// Maps sequence element to Void type.
    ///
    /// - Returns: Sequence where element is of Void type.
    func mapToVoid() -> Single<Void> {
        return mapTo(())
    }
    
}
