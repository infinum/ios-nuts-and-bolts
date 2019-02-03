//
//  Observable+Utility.swift
//  Catalog
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType {
    
    /// Converts current Observable sequence to Driver, completing on error event.
    ///
    /// - Returns: Driver - completing on error event
    public func asDriverOnErrorComplete() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
    /// Maps each sequence elements to given value.
    ///
    /// - Parameter value: Value to map
    /// - Returns: Sequence where all elements are given value.
    func mapTo<T>(_ value: T) -> Observable<T> {
        return map { _ in value }
    }
    
    /// Maps each sequence element to Void type.
    ///
    /// - Returns: Sequence where all elements are of Void type.
    func mapToVoid() -> Observable<Void> {
        return mapTo(())
    }
    
}

public extension ObservableConvertibleType {
    
    func pipe<T>(to function: (Self) -> (T)) -> T {
        return function(self)
    }
    
}
