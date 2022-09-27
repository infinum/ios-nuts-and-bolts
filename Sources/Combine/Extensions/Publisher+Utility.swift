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

    /// Erases the Publisher's error type
    ///
    /// - Returns: Publisher with a Failure type of Error
    func eraseError() -> Publishers.MapError<Self, Error> {
        return mapError { $0 as Error }
    }

    /// Catches the error converting it into the specified value
    ///
    /// - Returns: Publisher with the specified value
    func catchErrorReturn<T>(_ value: T) -> Publishers.Catch<Self, Just<T>> {
        return self.catch { _ in Just(value) }
    }

    /// Debounces the Publisher for a specified amount of time on the main queue
    ///
    /// - Returns: Publisher with debounce for a specified amount of time
    func debounce(for dueTime: DispatchQueue.SchedulerTimeType.Stride) -> Publishers.Debounce<Self, DispatchQueue> {
        return debounce(for: dueTime, scheduler: .main)
    }

    /// Maps each sequence element to Void type.
    ///
    /// - Returns: Sequence where all elements are of Void type.
    func mapToVoid() -> Publishers.Map<Self, Void> {
        return mapToValue(())
    }

    /// Prefixes elements of a sequence for the given `predicate` while also including the value at which the `prefix` operator stops.
    func inclusivePrefix(while predicate: @escaping (Self.Output) -> Bool) -> AnyPublisher<Self.Output, Failure> {
        return self
            .scan((current: Output?.none, priorWasFinal: false)) { state, new in
                // state.current is only nil for the first output from upstream,
                // in which case there was no prior element to be final.
                let priorWasFinal = !(state.current.map(predicate) ?? true)
                return (current: new, priorWasFinal: priorWasFinal)
            }
            .prefix(while: { !$0.priorWasFinal })
            .compactMap { $0.0 }
            .eraseToAnyPublisher()
    }
}

// MARK: Weak assign

@available(iOS 13.0, *)
public extension Publisher {

    /// Executes specified receiveValue closure if the value has been received, otherwise, if the Publisher
    /// error'd out, it executes the receiveError closure
    ///
    /// - Parameters:
    ///   - receiveValue: Closure which specifies what should be done if a value has been received
    ///   - receiveError: Closure which specifies what should be done if an error has been received
    ///
    /// - Returns: AnyCancellable
    func sink(
        receiveValue: @escaping ((Self.Output) -> Void),
        receiveError: @escaping ((Self.Failure) -> Void)
    ) -> AnyCancellable {
        return sink(
            receiveCompletion: { result in
                guard case .failure(let error) = result else { return }
                receiveError(error)
            },
            receiveValue: receiveValue
        )
    }

    /// Weakly assigns the received value to the specified object at the specified key path, if the Publisher errors out
    /// the error will be sent to the specified error handling subject
    ///
    /// - Parameters:
    ///   - object: Object on which you want to assing the value
    ///   - errorSubject: Subject which will handle the error if it happens
    ///   - valueKeyPath: Key path on the specified object to which you want to assign the value
    ///
    /// - Returns: AnyCancellable
    func assignWeakifed<T: AnyObject> (
        on object: T,
        errorAt errorSubject: PassthroughSubject<Error, Never>? = nil,
        valueAt valueKeyPath: ReferenceWritableKeyPath<T, Self.Output?>
    ) -> AnyCancellable {
        return sink(
            receiveValue: { [weak object] in object?[keyPath: valueKeyPath] = $0 },
            receiveError: { errorSubject?.send($0) }
        )
    }
}

@available(iOS 13.0, *)
public extension Publisher where Self.Failure == Never {

    /// Assigns the received value to the specified object which is weakified at the specified key path
    ///
    /// - Parameters:
    ///   - object: Object on which you want to assing the value
    ///   - keyPath: Key path on the specified object to which you want to assign the value
    ///
    /// - Returns: AnyCancellable
    func assignWeakified<T: AnyObject>(on object: T, at keyPath: ReferenceWritableKeyPath<T, Self.Output>) -> AnyCancellable {
        return assign(to: keyPath, on: object, ownership: .weak)
    }

    /// Assigns the received value to the specified object which is unowned at the specified key path
    ///
    /// - Parameters:
    ///   - object: Object on which you want to assing the value
    ///   - keyPath: Key path on the specified object to which you want to assign the value
    ///
    /// - Returns: AnyCancellable
    func assignUnowned<T: AnyObject>(on object: T, at keyPath: ReferenceWritableKeyPath<T, Self.Output>) -> AnyCancellable {
        return assign(to: keyPath, on: object, ownership: .unowned)
    }
}

// MARK: - Utility operators

@available(iOS 13.0, *)
public extension AnyPublisher {

    /// Creates an instance of AnyPublisher which sends one value and completes
    ///
    /// - Parameters:
    ///  - value: value which will be sent out when the publisher is subscribed to
    ///
    /// - Returns: AnyPublisher
    static func just(_ value: Output) -> AnyPublisher<Output, Failure> {
        return Just(value)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    /// Creates an instance of AnyPublisher which sends one error and completes
    ///
    /// - Parameters:
    ///  - error: error which will be sent out when the publisher is subscribed to
    ///
    /// - Returns: AnyPublisher
    static func error(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
