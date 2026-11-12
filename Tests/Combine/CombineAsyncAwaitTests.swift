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

@available(iOS 15.0, *)
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
                AnyPublisher<Int, Error>.just(0)
                    .createAsync(task: { [unowned self] in await getValue() })
                    .sink(
                        receiveValue: { value = $0 },
                        receiveError: { _ in } 
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should await throwing value of 1") {
                var value: Int?
                AnyPublisher<Int, Error>
                    .just(1)
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
                AnyPublisher<Int, Error>.just(1)
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
                AnyPublisher<Int, Error>.just(1)
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
                AnyPublisher<Void, TestError>.just(())
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

@available(iOS 15.0, *)
final class AsyncPublisherSubscriptionTests: XCTestCase {

    func testDoesNotStartWithoutDemand() {
        let started = expectation(description: "Task must wait for demand")
        started.isInverted = true
        var subscription: Subscription?
        let subscriber = AnySubscriber<Int, Error>(
            receiveSubscription: { subscription = $0 },
            receiveValue: { _ in .none },
            receiveCompletion: { _ in }
        )

        Catalog.AsyncPublisher {
            started.fulfill()
            return 1
        }.subscribe(subscriber)
        subscription?.request(.none)

        wait(for: [started], timeout: 0.1)
        subscription?.cancel()
    }

    func testStartsOnlyOnceWhenDemandIsRequested() {
        let started = expectation(description: "Task started once")
        let completed = expectation(description: "Publisher completed once")
        var subscription: Subscription?
        let subscriber = AnySubscriber<Int, Error>(
            receiveSubscription: { subscription = $0 },
            receiveValue: { value in
                XCTAssertEqual(value, 1)
                subscription?.request(.max(1))
                return .max(1)
            },
            receiveCompletion: { completion in
                guard case .finished = completion else {
                    XCTFail("Task should complete successfully")
                    return
                }
                completed.fulfill()
            }
        )

        Catalog.AsyncPublisher {
            started.fulfill()
            return 1
        }.subscribe(subscriber)
        subscription?.request(.max(1))
        subscription?.request(.unlimited)

        wait(for: [started, completed], timeout: 1)
        subscription?.cancel()
    }

    func testCancellationBeforeDemandPreventsWork() {
        let started = expectation(description: "Cancelled task must not start")
        started.isInverted = true
        let subscriber = AnySubscriber<Int, Error>(
            receiveSubscription: {
                $0.cancel()
                $0.request(.max(1))
            },
            receiveValue: { _ in .none },
            receiveCompletion: { _ in }
        )

        Catalog.AsyncPublisher {
            started.fulfill()
            return 1
        }.subscribe(subscriber)

        wait(for: [started], timeout: 0.1)
    }

    func testCancellationStopsTaskAndSuppressesDelivery() {
        let started = expectation(description: "Task started")
        let cancelled = expectation(description: "Task cancelled")
        let delivered = expectation(description: "Cancelled publisher must not deliver events")
        delivered.isInverted = true
        let subscription = Catalog.AsyncPublisher {
            started.fulfill()
            do {
                try await Task.sleep(nanoseconds: 10_000_000_000)
            } catch {
                cancelled.fulfill()
            }
            return 1
        }.sink(
            receiveCompletion: { _ in delivered.fulfill() },
            receiveValue: { _ in delivered.fulfill() }
        )

        wait(for: [started], timeout: 1)
        subscription.cancel()
        wait(for: [cancelled], timeout: 1)
        wait(for: [delivered], timeout: 0.1)
    }
}

// MARK: Async

@available(iOS 15.0, *)
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
