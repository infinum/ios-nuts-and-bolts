//
//  AnyPublisher+AsyncAwait.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineExt

@available(iOS 13.0, *)
public extension AnyPublisher {

    /// Create a new publisher for the given async task, returning output and finishing or erroring in case of a failure.
    /// 
    /// - Parameters:
    ///   - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    static func createAsync(
        task: @escaping () async throws -> Output,
        cancellationHandler: (() -> Void)? = nil
    ) -> AnyPublisher<Output, Failure> where Failure == Error {
        return AnyPublisher.create { subscriber in
            let task = Task {
                do {
                    let output = try await task()
                    subscriber.send(output)
                    subscriber.send(completion: .finished)
                } catch {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable { task.cancel() }
        }
    }

    /// Create a new publisher for the given async task, returning output and finishing.
    ///
    /// - Parameters:
    ///   - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    static func createAsync(task: @escaping () async -> Output) -> AnyPublisher<Output, Failure> where Failure == Never {
        return AnyPublisher.create { subscriber in
            let task = Task {
                let output = await task()
                subscriber.send(output)
                subscriber.send(completion: .finished)
            }
            return AnyCancellable { task.cancel() }
        }
    }

    /// Create a new publisher for the given async task, returning output and finishing or erroring in case of a failure.
    ///
    /// - Parameters:
    ///  - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task. Error will not be thrown in this case.
    static func createAsyncResult(task: @escaping () async throws -> Output) -> AnyPublisher<Result<Output, Failure>, Never> where Failure == Error {
        return AnyPublisher
            .createAsync(task: task)
            .mapToResult()
    }

    /// Create a new publisher for the given async task, returning output and finishing.
    ///
    /// - Parameters:
    ///  - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    static func createAsyncResult(task: @escaping () async -> Output) -> AnyPublisher<Result<Output, Failure>, Never> where Failure == Never {
        return AnyPublisher
            .createAsync(task: task)
            .mapToResult()
    }
}
