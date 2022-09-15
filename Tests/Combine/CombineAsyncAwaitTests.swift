//
//  CombineAsyncAwaitTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Combine
import CombineExt
@testable import Catalog

@available(iOS 13.0, *)
class CombineAsyncAwaitTests: QuickSpec {

    enum TestError: Error {
        case test
    }

    override func spec() {

        describe("test combine binding extensions") {

            var cancellables = Set<AnyCancellable>()

            beforeEach {
                cancellables = []
            }

            it("should await not throwing value of 1") {
                var value: Int?
                AnyPublisher
                    .createAsync(task: { [unowned self] in await getValue() })
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should await throwing value of 1") {
                var value: Int?
                AnyPublisher
                    .createAsync(task: { [unowned self] in try await getThrowingValue() })
                    .sink(
                        receiveValue: { value = $0 },
                        receiveError: { _ in }
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should await not throwing result of 1") {
                var value: Int?
                AnyPublisher
                    .createAsyncResult(task: { [unowned self] in await getValue() })
                    .sink(receiveValue: {
                        guard case .success(let number) = $0 else {
                            return
                        }
                        value = number
                    })
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should await throwing result of 1") {
                var value: Int?
                AnyPublisher
                    .createAsyncResult(task: { [unowned self] in try await getThrowingValue() })
                    .sink(
                        receiveValue: {
                            guard case .success(let number) = $0 else {
                                return
                            }
                            value = number
                        },
                        receiveError: { _ in }
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should throw an error") {
                var error: TestError?
                AnyPublisher
                    .createAsync(task: { [unowned self] in try await throwError() })
                    .sink(
                        receiveValue: { _ in },
                        receiveError: { error = $0 as? TestError }
                    )
                    .store(in: &cancellables)

                expect(error).toEventually(equal(TestError.test), timeout: .seconds(3))
            }
        }
    }
}

// MARK: Async

@available(iOS 13.0, *)
private extension CombineAsyncAwaitTests {

    func getValue() async -> Int {
        await withCheckedContinuation({ continuation in
            continuation.resume(returning: 1)
        })
    }

    func getThrowingValue() async throws -> Int {
        try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(returning: 1)
        })
    }

    func throwError() async throws -> Int {
        try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(throwing: TestError.test)
        })
    }
}
