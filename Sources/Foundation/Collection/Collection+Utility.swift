//
//  Collection+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public extension Collection {

    func mapEmptyToNil() -> Self? {
        return isEmpty ? nil : self
    }

    var isNotEmpty: Bool { !isEmpty }
}

public extension Optional where Wrapped: Collection {

    var isEmpty: Bool { self?.isEmpty ?? true }

    var isNotEmpty: Bool { self?.isNotEmpty ?? false }
}
