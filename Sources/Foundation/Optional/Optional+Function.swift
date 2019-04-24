//
//  Optional+Function.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Optional {
    
    /// Executes `function` if optional is .some, otherwise nothing happens.
    ///
    /// - Parameter function: Function to be executed.
    func forValue(do function: (Wrapped) -> ()) {
        if let value = self {
            function(value)
        }
    }
    
}
