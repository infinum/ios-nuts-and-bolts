//
//  AnyPublisher+AsyncAwait.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineExt

@available(iOS 15.0, *)
public struct AsyncPublisher<Output>: Publisher {

    public typealias Output = Output
    public typealias Failure = Error

    // MARK: - Private properties -

    private let task: () async throws -> Output

    // MARK: - Init -

    public init(task: @escaping () async throws -> Output) {
        self.task = task
    }

    // MARK: - Receive subscription -

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(task: task, target: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Extensions -

// MARK: - Subscription

@available(iOS 15.0, *)
private extension AsyncPublisher {

    final class Subscription<Target: Subscriber>: Combine.Subscription where Target.Input == Output, Target.Failure == Error {

        private var task: Task<Void, Error>?
        private let asyncTask: () async throws -> Output
        private var subscriber: Target?

        init(task: @escaping () async throws -> Output, target: Target) {
            self.asyncTask = task
            subscriber = target
            getData()
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            subscriber = nil
            task?.cancel()
        }

        private func getData() {
            task = Task {
                do {
                    let value = try await asyncTask()
                    _ = subscriber?.receive(value)
                    subscriber?.receive(completion: .finished)
                } catch {
                    subscriber?.receive(completion: .failure(error))
                }
            }
        }
    }
}

// MARK: - Creation

@available(iOS 15.0, *)
public extension Publisher {
    /// Create a new publisher for the given async task, returning output and finishing.
    ///
    /// - Parameters:
    ///   - task: A work task that needs to be executed and converted into `AsyncPublisher`.
    ///
    /// - Returns: An `AsyncPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    func createAsync<Output>(task: @escaping () async throws -> Output) -> AsyncPublisher<Output> {
        return AsyncPublisher(task: task)
    }

    /// Create a new publisher for the given async task, returning output and finishing.
    ///
    /// - Parameters:
    ///  - task: A work task that needs to be executed and converted into `AsyncPublisher`.
    ///
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    func createAsyncResult<Output>(task: @escaping () async throws -> Output)
    -> Publishers.Catch<Publishers.Map<AsyncPublisher<Output>, Result<Output, Error>>, Just<Result<Output, Error>>> {
        return AsyncPublisher(task: task)
            .map(Result.success)
            .catch { Just(.failure($0)) }
    }
}
