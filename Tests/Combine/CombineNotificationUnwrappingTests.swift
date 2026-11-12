//
//  CombineNotificationUnwrappingTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 28.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Combine
import CombineExt
@testable import Catalog

@available(iOS 13.0, *)
class CombineNotificationUnwrappingTests: QuickSpec {

    override func spec() {

        describe("test combine notification unwrapping") {

            var cancellables = Set<AnyCancellable>()

            beforeEach {
                cancellables = []
            }

            it("should get the value") {
                let relay = PassthroughRelay<String>()
                var value: String?

                relay
                    .unwrapNotificationObject(for: .init(rawValue: "testNotification"), with: "test")
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                NotificationCenter.default.post(.init(name: .init(rawValue: "testNotification"), object: ["test": "coolValue"]))
                NotificationCenter.default.post(.init(name: .init(rawValue: "testNotification"), object: ["test": "coolValue2"]))

                expect(value).toEventually(equal("coolValue2"), timeout: .seconds(3))
            }

            it("wrong key, should not get the value") {
                let relay = PassthroughRelay<String>()
                var value: String?

                relay
                    .unwrapNotificationObject(for: .init(rawValue: "testNotification"), with: "test2")
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                NotificationCenter.default.post(.init(name: .init(rawValue: "testNotification"), object: ["test": "coolValue"]))
                NotificationCenter.default.post(.init(name: .init(rawValue: "testNotification"), object: ["test": "coolValue2"]))

                expect(value).toEventually(beNil(), timeout: .seconds(3))
            }

            it("no objects sent, should not get the value") {
                let relay = PassthroughRelay<String>()
                var value: String?

                relay
                    .unwrapNotificationObject(for: .init(rawValue: "testNotification"), with: "test")
                    .sink(receiveValue: { value = $0 })
                    .store(in: &cancellables)

                expect(value).toEventually(beNil(), timeout: .seconds(3))
            }
        }
    }
}
