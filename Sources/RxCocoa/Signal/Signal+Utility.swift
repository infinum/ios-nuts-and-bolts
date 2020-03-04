//
//  Signal+Utility.swift
//  Catalog
//
//  Created by Filip Gulan on 13/09/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {

    /// Creates new subscription and sends elements to `PublishRelay`.
    ///
    /// - Parameter relay: PublishRelay instance
    /// - Returns: Disposable for current subscription
    func emit(_ relay: PublishRelay<Element>) -> Disposable {
        return emit(onNext: { e in relay.accept(e) })
    }
    
    /// Safely unwraps optional value from chain
    func compactMap<T>() -> Signal<T> where Element == Optional<T> {
        return compactMap { $0 }
    }

    /// Returns a sequence by the source observable sequence
    /// shifted forward in time by a specified delay.
    /// Error events from the source observable sequence are not delayed.
    ///
    /// - Parameter dueTime: Delay time interval (seconds)
    /// - Returns: Delayed sequnece
    func delay(dueTime: RxTimeInterval) -> Signal<Element> {
        return self
            .asObservable()
            .delay(dueTime, scheduler: MainScheduler.instance)
            .asSignal(onErrorSignalWith: .empty())
    }

    /// Returns a specified number of contiguous elements from the start of an observable sequence.
    ///
    /// - Parameter count: The number of elements to return.
    /// - Returns: A sequence that contains the specified number of elements from the start of the input sequence.
    func take(_ count: Int) -> Signal<Element> {
        return self
            .asObservable()
            .take(count)
            .asSignal(onErrorSignalWith: .empty())
    }

    /// Maps each sequence elements to given value.
    ///
    /// - Parameter value: Value to map
    /// - Returns: Sequence where all elements are given value.
    func mapTo<T>(_ value: T) -> Signal<T> {
        return map { _ in value }
    }

    /// Maps each sequence element to Void type.
    ///
    /// - Returns: Sequence where all elements are of Void type.
    func mapToVoid() -> Signal<Void> {
        return mapTo(())
    }
}
