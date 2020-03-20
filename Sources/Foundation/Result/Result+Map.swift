//
//  Result+Map.swift
//  Catalog
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation

public extension Result {
    
    /// Maps Result Success type to Void
    var mapToVoid: Result<Void, Failure> {
        return self.map { _ in () }
    }
}
