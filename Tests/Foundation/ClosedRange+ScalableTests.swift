//
//  ClosedRange+ScalableTests.swift
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class ClosedRange_ScalableTests: QuickSpec {

    override func spec() {

        describe("testing scaling values between two ranges") {
            
            it("should scale between two ranges: smaller -> bigger") {
                let startInterval = CGFloat(0.0)...CGFloat(1.0)
                let endInterval = CGFloat(0.0)...CGFloat(100.0)
                
                let scaled = startInterval.scale(value: 0.5, toInterval: endInterval)
                expect(scaled).to(equal(50))
            }
            
            it("should scale between two ranges: bigger -> smaller") {
                let startInterval = CGFloat(0.0)...CGFloat(100.0)
                let endInterval = CGFloat(0.0)...CGFloat(1.0)
                
                let scaled = startInterval.scale(value: 50, toInterval: endInterval)
                expect(scaled).to(equal(0.5))
            }
            
            it("should scale between two ranges: negative bigger -> smaller") {
                let startInterval = CGFloat(-100.0)...CGFloat(100.0)
                let endInterval = CGFloat(0.0)...CGFloat(1.0)
                
                let scaled = startInterval.scale(value: 0, toInterval: endInterval)
                expect(scaled).to(equal(0.5))
            }
            
        }

    }
}
