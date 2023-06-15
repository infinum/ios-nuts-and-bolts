//
//  NotificationCenterPublisher.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public struct NotificationCenterPublisher<Output>: Publisher {

    public typealias Output = Output
    public typealias Failure = Never

    // MARK: - Private properties -

    private let notificationName: Notification.Name
    private let key: String

    // MARK: - Init -

    public init(notificationName: Notification.Name, key: String) {
        self.notificationName = notificationName
        self.key = key
    }

    // MARK: - Receive subscription -

    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
        let subscription = Subscription(notificationName: notificationName, key: key, target: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Extensions -

// MARK: - Subscription

@available(iOS 13.0, *)
private extension NotificationCenterPublisher {

    final class Subscription<Target: Subscriber>: Combine.Subscription where Target.Input == Output, Target.Failure == Never {

        private let notificationName: Notification.Name
        private let key: String
        private var subscriber: Target?

        init(notificationName: Notification.Name, key: String, target: Target) {
            self.notificationName = notificationName
            self.key = key
            subscriber = target
            getObject(key: key)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            subscriber = nil
        }

        private func getObject(key: String) {
            guard let subscriber = subscriber else { return }

            NotificationCenter.default.publisher(for: notificationName)
                .compactMap { $0.object as? NSDictionary }
                .compactMap { $0[key] as? Output }
                .receive(subscriber: subscriber)
        }
    }
}

// MARK: - Creation

@available(iOS 13.0, *)
public extension Publisher {

    /// Unwraps the notifications for the specified type at the speficied key
    ///
    /// - Parameters:
    ///  - key: Key at which the object will be unwrapped
    ///  - type: Type of the object to which it will try to unwrap
    ///
    /// - Returns: AnyPublisher with the unwrapped value if there is one
    func unwrapNotificationObject(for name: Notification.Name, with key: String) -> NotificationCenterPublisher<Output> {
        return NotificationCenterPublisher(notificationName: name, key: key)
    }
}
