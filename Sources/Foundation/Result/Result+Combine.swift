//
//  Result+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation

public extension Result {

    var toCompletableResult: Result<Void, Failure> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success:
            return .success(())
        }
    }
}
