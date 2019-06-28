//
//  URL+AppendTests.swift
//
//  Created by Filip Gulan on 12/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class URL_AppendTests: QuickSpec {

    override func spec() {

        describe("test appending query items to URL") {

            it("should add query items to the basic url") {
                let iPhone = URLQueryItem(name: "iphone", value: "x")
                let iPad = URLQueryItem(name: "ipad", value: "pro")
                let url = URL(string: "https://www.apple.com/devices")!

                let newUrl = url.appendingQueryItems([iPhone, iPad])
                expect(newUrl.absoluteString).to(equal("https://www.apple.com/devices?iphone=x&ipad=pro"))
            }

            it("should append query items to the url with query items") {
                let iPhone = URLQueryItem(name: "iphone", value: "x")
                let iPad = URLQueryItem(name: "ipad", value: "pro")
                let url = URL(string: "https://www.apple.com/devices?ipod=nano")!

                let newUrl = url.appendingQueryItems([iPhone, iPad])
                expect(newUrl.absoluteString).to(equal("https://www.apple.com/devices?ipod=nano&iphone=x&ipad=pro"))
            }

            it("appending empty array should not change the url") {
                let url = URL(string: "https://www.apple.com/devices?ipod=nano")!

                let newUrl = url.appendingQueryItems([])
                expect(newUrl.absoluteString).to(equal("https://www.apple.com/devices?ipod=nano"))
            }

         }

    }
}
