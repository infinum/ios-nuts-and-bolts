//
//  EdgeInsetsTestCase.swift
//  Tests
//
//  Created by Infinum on 28.07.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import Foundation
import XCTest
import Quick
import Nimble
@testable import Catalog

class UIEdgeInsetsTestCase: QuickSpec {

    override func spec() {

        describe("UIEdgeInsetsTestCase") {
            it("Initializers") {
                var insets: UIEdgeInsets

                insets = .allEqual(16)
                expect(insets).to(equal(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)))

                insets = .topAndBottom(8)
                expect(insets).to(equal(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)))

                insets = .leftAndRight(9)
                expect(insets).to(equal(UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)))

                insets = .init(leftRight: 4, topBottom: 8)
                expect(insets).to(equal(UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)))

                insets = .onlyAt(left: 8)
                expect(insets).to(equal(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)))

                insets = .init(top: 1, left: 3, bottom: 5, right: 6)
                expect(insets.leftAndRight).to(equal(9))
                expect(insets.topAndBottom).to(equal(6))
                expect(insets.inversed).to(equal(UIEdgeInsets(top: -1, left: -3, bottom: -5, right: -6)))
            }
        }
    }
}
