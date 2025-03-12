//
//  Optional+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { !isNil }
}
