//
//  Optional+UtilityTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class OptionalUtilityTests: QuickSpec {

    override func spec() {

        describe("String optional tests") {

            it("isNil should be true") {
                let value: Int? = nil

                expect(value.isNil).to(beTrue())
            }

            it("isNil should be false") {
                let value: Int? = 5

                expect(value.isNil).to(beFalse())
            }

            it("isNotNil should be false") {
                let value: Int? = nil

                expect(value.isNotNil).to(beTrue())
            }

            it("isNotNil should be true") {
                let value: Int? = 5

                expect(value.isNotNil).to(beFalse())
            }
        }
    }
}
