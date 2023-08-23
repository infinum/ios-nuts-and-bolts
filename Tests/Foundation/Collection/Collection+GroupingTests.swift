//
//  Collection+GroupingTests.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class CollectionGroupingTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing group(by:)") {
            
            it("Should group input array of tuples") {
                
                struct Element: Equatable {
                    let num: Int
                    let char: String
                }
                
                let array = [
                    Element(num: 1, char: "A"),
                    Element(num: 2, char: "B"),
                    Element(num: 3, char: "C"),
                    Element(num: 1, char: "D"),
                    Element(num: 2, char: "E"),
                    Element(num: 3, char: "F")
                ]
                
                let expected = [
                    [
                        Element(num: 1, char: "A"),
                        Element(num: 1, char: "D")
                    ],
                    [
                        Element(num: 2, char: "B"),
                        Element(num: 2, char: "E")
                    ],
                    [
                        Element(num: 3, char: "C"),
                        Element(num: 3, char: "F")
                    ]
                ]
                
                let result = array.groupBy { $0.num }
                
                expect(result) == expected
            }
            
            it("Should preserve initial order") {
                let array = [3, 2, 1, 4, 5]
                let expected = [
                    [3],
                    [2],
                    [1],
                    [4],
                    [5]
                ]
                
                let result = array.groupBy { $0 }
                
                expect(result).to(equal(expected))
            }
            
            it("Should return inputed array") {
                let array = [3, 2, 1, 4, 5]
                
                let result = array.groupBy { _ in true }
                
                expect(result).to(equal([array]))
            }
        }
        
    }
}

