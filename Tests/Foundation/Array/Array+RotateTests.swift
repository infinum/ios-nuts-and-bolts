//
//  Array+RotateTests.swift
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class ArrayRotateTests: QuickSpec {

    override func spec() {

        describe("testing array extension for rotating") {
            
            let array: [Int] = [1, 2, 3, 4, 5]
            
            /// Right
            it("should shift to right for 1 place") {
                let result = array.rotated(for: 1)
                expect(result).to(equal([5, 1, 2, 3, 4]))
            }
            
            it("should shift to right for 3 places") {
                let result = array.rotated(for: 3)
                expect(result).to(equal([3, 4, 5, 1, 2]))
            }
            
            it("should shift to right for 5 places") {
                let result = array.rotated(for: 5)
                expect(result).to(equal([1, 2, 3, 4, 5]))
            }
            
            it("should shift to right for 6 places") {
                let result = array.rotated(for: 6)
                expect(result).to(equal([5, 1, 2, 3, 4]))
            }
            
            /// Zero
            it("should shift for 0 places") {
                let result = array.rotated(for: 0)
                expect(result).to(equal([1, 2, 3, 4, 5]))
            }
            
            /// Left
            it("should shift to left for 1 place") {
                let result = array.rotated(for: -1)
                expect(result).to(equal([2, 3, 4, 5, 1]))
            }
            
            it("should shift to left for 3 places") {
                let result = array.rotated(for: -3)
                expect(result).to(equal([4, 5, 1, 2, 3]))
            }
            
            it("should shift to left for 5 places") {
                let result = array.rotated(for: -5)
                expect(result).to(equal([1, 2, 3, 4, 5]))
            }
            
            it("should shift to left for 6 places") {
                let result = array.rotated(for: -6)
                expect(result).to(equal([2, 3, 4, 5, 1]))
            }
            
            /// Special arrays
            
            // Empty
            it("should return empty array, right shift") {
                let result = [Int]().rotated(for: 2)
                expect(result).to(equal([]))
            }
            
            it("should return empty array, left shift") {
                let result = [Int]().rotated(for: -2)
                expect(result).to(equal([]))
            }
            
            it("should return empty array, no shift") {
                let result = [Int]().rotated(for: 0)
                expect(result).to(equal([]))
            }
            
            // One element
            it("should return empty array, right shift") {
                let result = [1].rotated(for: 2)
                expect(result).to(equal([1]))
            }
            
            it("should return empty array, left shift") {
                let result = [1].rotated(for: -2)
                expect(result).to(equal([1]))
            }
            
            it("should return empty array, no shift") {
                let result = [1].rotated(for: 0)
                expect(result).to(equal([1]))
            }
            
        }

    }
}
