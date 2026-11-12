//
//  UIColor+HexTests.swift
//
//  Created by Mario Galijot on 21/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Quick
import Nimble
@testable import Catalog

class UIColorHexTests: QuickSpec {
    
    override func spec() {
        
        describe("testing UIColor with HEX") {
         
            it("should create the same color for both RGB and corresponding HEX") {
                
                let rgbValue: CGFloat = 255.0
                let rgbColor = UIColor(r: rgbValue, g: rgbValue, b: rgbValue)
                
                /* Testing HEX without alpha */
                var hexValue: String = "#FFFFFF"
                var hexColor = UIColor(hex: hexValue)
                expect(rgbColor).to(equal(hexColor))
                
                expect(rgbColor.getHex(withAlpha: false)).toNot(beNil())
                expect(rgbColor.getHex(withAlpha: false)).to(equal(hexValue))
                
                expect(hexColor.getHex(withAlpha: false)).toNot(beNil())
                expect(hexColor.getHex(withAlpha: false)).to(equal(hexValue))
                
                /* Testing HEX with alpha */
                hexValue = "#FFFFFFFF" // last 2 characters are used for alpha
                hexColor = UIColor(hex: hexValue)
                expect(rgbColor).to(equal(hexColor))
                
                expect(rgbColor.getHex(withAlpha: true)).toNot(beNil())
                expect(rgbColor.getHex(withAlpha: true)).to(equal(hexValue))
                
                expect(hexColor.getHex(withAlpha: true)).toNot(beNil())
                expect(hexColor.getHex(withAlpha: true)).to(equal(hexValue))
            }
        }
    }
}
