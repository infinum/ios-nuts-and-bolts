//
//  UIControl+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import Combine

// https://github.com/CombineCommunity/CombineCocoa/blob/main/Sources/CombineCocoa/CombineControlProperty.swift
// MARK: - Publisher
@available(iOS 13.0, *)
public extension Combine.Publishers {
    /// A Control Property is a publisher that emits the value at the provided keypath
    /// whenever the specific control events are triggered. It also emits the keypath's
    /// initial value upon subscription.
    struct ControlProperty<Control: UIControl, Value>: Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        private let control: Control
        private let controlEvents: Control.Event
        private let keyPath: KeyPath<Control, Value>

        /// Initialize a publisher that emits the value at the specified keypath
        /// whenever any of the provided Control Events trigger.
        ///
        /// - parameter control: UI Control.
        /// - parameter events: Control Events.
        /// - parameter keyPath: A Key Path from the UI Control to the requested value.
        public init(
            control: Control,
            events: Control.Event,
            keyPath: KeyPath<Control, Value>
        ) {
            self.control = control
            self.controlEvents = events
            self.keyPath = keyPath
        }

        public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(
                subscriber: subscriber,
                control: control,
                event: controlEvents,
                keyPath: keyPath
            )

            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Subscription
@available(iOS 13.0, *)
extension Combine.Publishers.ControlProperty {
    private final class Subscription<S: Subscriber, Control: UIControl, Value>: Combine.Subscription where S.Input == Value {
        private var subscriber: S?
        private weak var control: Control?
        let keyPath: KeyPath<Control, Value>
        private var didEmitInitial = false
        private let event: Control.Event

        init(subscriber: S, control: Control, event: Control.Event, keyPath: KeyPath<Control, Value>) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            self.event = event
            control.addTarget(self, action: #selector(handleEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
            // Emit initial value upon first demand request
            if !didEmitInitial,
                demand > .none,
                let control = control,
                let subscriber = subscriber {
                _ = subscriber.receive(control[keyPath: keyPath])
                didEmitInitial = true
            }

            // We don't care about the demand at this point.
            // As far as we're concerned - UIControl events are endless until the control is deallocated.
        }

        func cancel() {
            control?.removeTarget(self, action: #selector(handleEvent), for: event)
            subscriber = nil
        }

        @objc
        private func handleEvent() {
            guard let control = control else { return }
            _ = subscriber?.receive(control[keyPath: keyPath])
        }
    }
}

extension UIControl.Event {
    static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}
