//
//  CombineUtilityTests.swift
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
class CombineUtilityTests: QuickSpec {

    enum TestError: Error, Equatable {
        case test
    }

    override func spec() {

        describe("test combine utility extensions") {

            var cancellables = Set<AnyCancellable>()

            beforeEach {
                cancellables = []
            }

            it("should return error immediately") {
                var error: TestError?
                AnyPublisher.error(TestError.test)
                    .sink(
                        receiveCompletion: {
                            guard case .failure(let currentError) = $0 else { return }
                            error = currentError
                        },
                        receiveValue: { }
                    )
                    .store(in: &cancellables)

                expect(error).toEventually(equal(TestError.test), timeout: .seconds(3))
            }

            it("should return value immediately") {
                var value: Int?
                AnyPublisher<Int, Never>.just(1)
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should execute receiveError closure") {
                var error: TestError?
                AnyPublisher.error(TestError.test)
                    .sink(
                        receiveValue: { },
                        receiveError: { error = $0 }
                    )
                    .store(in: &cancellables)

                expect(error).toEventually(equal(TestError.test), timeout: .seconds(3))
            }

            it("should not execute receiveErrorClosure") {
                var error: TestError?
                AnyPublisher.just(1)
                    .sink(
                        receiveValue: { _ in },
                        receiveError: { error = $0 }
                    )
                    .store(in: &cancellables)

                expect(error).toEventually(equal(nil), timeout: .seconds(3))
            }

            it("should execute receiveValueClosure") {
                var value: Int?
                AnyPublisher<Int, Never>.just(1)
                    .sink(
                        receiveValue: { value = $0 },
                        receiveError: { _ in }
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should not execute receiveValueClosure") {
                var value: Int?
                AnyPublisher<Int, TestError>.error(TestError.test)
                    .sink(
                        receiveValue: { value = $0 },
                        receiveError: { _ in }
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(nil), timeout: .seconds(3))
            }

            it("should return integer value and not error out") {
                var value: Int?
                AnyPublisher<Int, TestError>.error(TestError.test)
                    .catchErrorReturn(1)
                    .sink(
                        receiveValue: { value = $0 },
                        receiveError: { _ in }
                    )
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }
         }
    }
}
