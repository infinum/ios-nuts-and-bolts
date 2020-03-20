//
//  Result+Rx.swift
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Result {
    
    /// Maps current result to SingleEvent type used for Single Rx trait
    var toSingleEvent: SingleEvent<Success> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .error(error)
        }
    }
    
    /// Maps current result to CompletableEvent type used for Completable Rx trait
    var toCompletableEvent: CompletableEvent {
        switch self {
        case .success:
            return .completed
        case .failure(let error):
            return .error(error)
        }
    }
}
