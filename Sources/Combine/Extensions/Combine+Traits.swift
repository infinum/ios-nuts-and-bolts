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

    /// Converts current Publisher sequence to a `Driver`. Events are received on the `Main` queue, the sequence is `shared` and `replayed`. Be aware that it is share forever.
    ///
    /// - Returns: A `Driver` publisher.
    func asDriver() -> CombineDriver<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 1)
    }

    /// Converts current Publisher sequence to a `Signal`. Events are received on the `Main` queue, the sequence is `shared`. Be aware that it is share forever.
    ///
    /// - Returns: A `Signal` publisher.
    func asSignal() -> CombineSignal<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 0)
    }

    func asWhileConnectedDriver() -> AnyPublisher<Output, Never> {
        receive(on: DispatchQueue.main)
            .shareReplayLatestWhileConnected()
            .eraseToAnyPublisher()
    }

    // Change the name once you decide which Signal you're going to use, share(replay:) can have memory leaks
    func asNonShareReplaySignal() -> AnyPublisher<Output, Never> {
        receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
public extension ShareReplayPublisher {

    // Use this with CombineExt, potential leaks with share(replay:)
    static func just(_ value: Output, replay: Bool = true) -> CombineDriver<Output> {
        guard replay else {
            return Just(value).asSignal()
        }
        return Just(value).asDriver()
    }
}

@available(iOS 13.0, *)
public extension Publishers {

    // Use this if you don't want to use CombineExt
    static func just<Output>(_ value: Output, replay: Bool) -> AnyPublisher<Output, Never> {
        guard replay else {
            return Just(value).asNonShareReplaySignal()
        }
        return Just(value).asWhileConnectedDriver()
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
