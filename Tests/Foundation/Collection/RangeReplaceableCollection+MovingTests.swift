//
//  RangeReplaceableCollection+MovingTests.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class RangeReplaceableCollection_MovingTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing moving(elementAt:to:)") {
            
            it ("Should set some middle element a few places closer to start of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [0, 4, 1, 2, 3, 5]
                expect(array.moving(elementAt: 4, to: 1)) == expected
            }
            
            it ("Should set some middle element a few places closer to end of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [0, 2, 3, 4, 1, 5]
                expect(array.moving(elementAt: 1, to: 4)) == expected
            }
            
            it ("Should set midle element to start of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [3, 0, 1, 2, 4, 5]
                expect(array.moving(elementAt: 3, to: 0)) == expected
            }
            
            it ("Should set midle element to end of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [0, 1, 2, 4, 5, 3]
                expect(array.moving(elementAt: 3, to: 5)) == expected
            }
            
            it ("Should set last element to start of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [5, 0, 1, 2, 3, 4]
                expect(array.moving(elementAt: 5, to: 0)) == expected
            }
            
            it ("Should set first element to end of the list") {
                let array = [0, 1, 2, 3, 4, 5]
                let expected = [1, 2, 3, 4, 5, 0]
                expect(array.moving(elementAt: 0, to: 5)) == expected
            }
            
        }
    }
}
