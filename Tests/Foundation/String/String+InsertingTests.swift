//
//  String+InsertingTests.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class String_InsertingTests: QuickSpec {
    
    override func spec() {
        
        describe("testing insertingCharacter(charToAdd:position:)") {
            
            it("should return starting string if position is negative") {
                let str = "test".insertingCharacter("!", at: -2)
                expect(str) == "test"
            }
            
            it("should return starting string if position is higher than string count") {
                let str = "test".insertingCharacter("!", at: 10)
                expect(str) == "test"
            }
            
            it("should return updated string if position is higher than string count") {
                let str = "test".insertingCharacter("!", at: 4)
                expect(str) == "test!"
            }
            
        }
        
        describe("testing insertingCharacter(charToAdd:positions:)") {
            
            it("should return starting string if positions is negative") {
                let str = "test".insertingCharacter("!", at: [-2])
                expect(str) == "test"
            }
            
            it("should return starting string if positions are higher than string count") {
                let str = "test".insertingCharacter("!", at: [7, 8])
                expect(str) == "test"
            }
            
            it("should only add chars at non-negative indexes") {
                let str = "test".insertingCharacter("!", at: [-2, 4])
                expect(str) == "test!"
            }
        
            it("should properly increase string count") {
                let str = "test".insertingCharacter("!", at: [4, 5])
                expect(str) == "test!!"
            }

        }
    }
}
