//
//  Validator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public protocol Validator {
    var invalidInputDescription: String { get }
    func validate(_ value: Any) -> Bool
}
