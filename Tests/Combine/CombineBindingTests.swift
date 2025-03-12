//
//  CombineBindingTests.swift
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
class CombineBindingTests: QuickSpec {

    override func spec() {

        describe("test combine binding extensions") {

            var cancellables = Set<AnyCancellable>()

            beforeEach {
                cancellables = []
            }

            it("should change value to 1") {
                var value: Int?
                let currentValueRelay = CurrentValueRelay<Int?>(nil)
                AnyPublisher.just(1)
                    .bind(to: currentValueRelay)
                    .store(in: &cancellables)

                currentValueRelay
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                expect(value).toEventually(equal(1), timeout: .seconds(3))
            }

            it("should change value to 2") {
                var value: Int?
                let passthroughRelay = CurrentValueRelay<Int?>(nil)
                passthroughRelay
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                AnyPublisher.just(2)
                    .bind(to: passthroughRelay)
                    .store(in: &cancellables)

                expect(value).toEventually(equal(2), timeout: .seconds(3))
            }
        }
    }
}
