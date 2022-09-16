//
//  Combine+Traits.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineExt

@available(iOS 13.0, *)
public extension Publisher {

    /// Converts current Publisher sequence to `Driver`, completing on error event.
    ///
    /// - Returns: Driver - completing on error event
    func asDriverOnErrorComplete() -> CombineDriver<Output> {
        ignoreFailure().asDriver()
    }

    /// Converts current Publisher sequence to `Signal`, completing on error event.
    ///
    /// - Returns: Signal - completing on error event
    func asSignalOnErrorComplete() -> CombineSignal<Output> {
        ignoreFailure().asSignal()
    }
}

@available(iOS 13.0, *)
public extension Publisher where Failure == Never {

    /// Converts current Publisher sequence to a `Driver`. Events are received on the `Main` queue, the sequence is `shared` and `replayed`.
    ///
    /// - Returns: A `Driver` publisher.
    func asDriver() -> CombineDriver<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 1)
    }

    /// Converts current Publisher sequence to a `Signal`. Events are received on the `Main` queue, the sequence is `shared`.
    ///
    /// - Returns: A `Signal` publisher.
    func asSignal() -> CombineSignal<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 0)
    }
}

@available(iOS 13.0, *)
public extension ShareReplayPublisher {

    static func just(_ value: Output, replay: Bool = true) -> CombineDriver<Output> {
        guard replay else {
            return AnyPublisher.just(value).asSignal()
        }
        return AnyPublisher.just(value).asDriver()
    }
}

@available(iOS 13.0, *)
public typealias ShareReplayPublisher<Output> = Publishers.Autoconnect
<Publishers.Multicast
<Publishers.ReceiveOn
<AnyPublisher<Output, Never>, DispatchQueue>, ReplaySubject<Output, Never>>>

@available(iOS 13.0, *)
public typealias CombineDriver<Output> = ShareReplayPublisher<Output>

@available(iOS 13.0, *)
public typealias CombineSignal<Output> = ShareReplayPublisher<Output>
