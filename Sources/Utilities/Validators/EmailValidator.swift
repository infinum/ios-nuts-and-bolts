//
//  EmailValidator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public struct EmailValidator: StringValidator {

    // Example invalid input description
    public var invalidInputDescription: String {
        "The email is not valid"
    }

    public func validate(_ value: String) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)

        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(trimmedValue.startIndex..<trimmedValue.endIndex, in: trimmedValue)
        let matches = detector?.matches(in: trimmedValue, options: [], range: range)

        // We only want our string to contain a single email
        guard let match = matches?.first, matches?.count == 1 else { return false }

        // Verify that the found link points to an email address, and that its range covers the whole input string
        guard match.url?.scheme == "mailto", match.range == range else { return false }

        return true
    }
}
