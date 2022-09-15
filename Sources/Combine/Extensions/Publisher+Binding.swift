//
//  Publisher+Binding.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineExt

@available(iOS 13.0, *)
public extension Publisher where Failure == Never {

    /// Binds the value to a specified relay
    func bind(to relay: PassthroughRelay<Output>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    /// Binds the value to a specified relay
    func bind(to relay: PassthroughRelay<Output?>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    /// Binds the value to a specified relay
    func bind(to relay: CurrentValueRelay<Output>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    /// Binds the value to a specified relay
    func bind(to relay: CurrentValueRelay<Output?>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }
}
