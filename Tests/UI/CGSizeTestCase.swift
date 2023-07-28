//
//  CGSizeTestCase.swift
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

class CGSizeExtensionsTestCase: QuickSpec {

    override func spec() {

        describe("CGSizeExtensionsTestCase") {
            it("Initializers, Change Size, Scale") {
                var size: CGSize

                size = .init(square: 8)
                expect(size.width).to(equal(8))
                expect(size.height).to(equal(8))

                size = .square(9)
                expect(size.width).to(equal(9))
                expect(size.height).to(equal(9))

                size = size.adding(size: .square(1))
                expect(size.width).to(equal(10))
                expect(size.height).to(equal(10))

                size = size.scaled(factor: 3)
                expect(size.width).to(equal(30))
                expect(size.height).to(equal(30))

                size = size.subtracting(size: .square(1))
                expect(size.width).to(equal(29))
                expect(size.height).to(equal(29))
            }

            it("Insets and Max/Min Size") {
                var size: CGSize
                size = .square(10)
                size = size.adding(insets: .init(top: 1, left: 2, bottom: 3, right: 4))
                expect(size.width).to(equal(16))
                expect(size.height).to(equal(14))
                expect(size.maxSide).to(equal(16))
                expect(size.minSide).to(equal(14))

                size = size.subtracting(insets: .init(top: 1, left: 2, bottom: 3, right: 4))
                expect(size.width).to(equal(10))
                expect(size.height).to(equal(10))
                expect(size.maxSide).to(equal(10))
                expect(size.minSide).to(equal(10))
            }
        }
    }
}
