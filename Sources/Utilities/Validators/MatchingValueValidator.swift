//
//  MatchingValueValidator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public struct MatchingValueValidator: StringValidator {

    public var valueToMatch: String?

    // Example invalid input description
    public var invalidInputDescription: String {
        "Specified input and the value to match don't match"
    }

    public func validate(_ value: String) -> Bool {
        return value == valueToMatch
    }
}
