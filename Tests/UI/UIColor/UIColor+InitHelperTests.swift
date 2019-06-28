//
//  UIColor+InitHelperTests.swift
//
//  Created by Mario Galijot on 21/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Quick
import Nimble
@testable import Catalog

class UIColor_InitHelperTests: QuickSpec {
    
    override func spec() {
        
        describe("testing UIColor init without dividing the R/G/B value with 255.0") {
            
            it("should initialize the same color object, as it normally would, with default initializer") {
                
                let value: CGFloat = 100
                
                let c1 = UIColor(r: value, g: value, b: value, alpha: 1)
                let c2 = UIColor(red: value / CGFloat(255.0), green: value / CGFloat(255.0), blue: value / CGFloat(255.0), alpha: 1)
                
                expect(c1).to(equal(c2))
            }
        }
    }
}
