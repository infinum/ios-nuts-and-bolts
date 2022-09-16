//
//  StringValidator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public protocol StringValidator: Validator {
    func validate(_ value: String) -> Bool
}

public extension StringValidator {

    func validate(_ value: Any) -> Bool {
        guard let string = value as? String else {
            assertionFailure("Wrong validation type passed to the `StringValidator`.")
            return false
        }
        return validate(string)
    }

    @available(*, unavailable)
    func validate(_ value: String) -> Bool {
        fatalError("Concrete type needs to implement the validation.")
    }
}
