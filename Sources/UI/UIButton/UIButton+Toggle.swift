//
//  UIButton+Toggle.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import RxSwift
import RxCocoa

public enum ToggleState: Equatable {

    case available(active: Bool)
    case unavailable
    case inProgress

    func toggleActivity() -> ToggleState {
        switch self {
        case .available(let active):
            return .available(active: !active)
        case .unavailable, .inProgress:
            return self
        }
    }
}

public protocol Togglable: AnyObject {

    /// Current state
    var toggleState: ToggleState { get }

    /// Sent signal with current state
    var tap: Signal<ToggleState> { get }

    /// Toggles the current state
    func toggle(with toggleState: ToggleState)

    /// Sets up receiving state changes
    func setup(with driver: Driver<ToggleState>) -> Disposable
}

public extension Reactive where Base: Togglable {

    var toggle: Binder<ToggleState> {
        Binder(self.base) { (button: Togglable, toggleState: ToggleState) in
            button.toggle(with: toggleState)
        }
    }
}

public extension Togglable where Self: UIButton {

    var tap: Signal<ToggleState> {
        rx.tap.asSignal().map { [unowned self] in self.toggleState }
    }

    func setup(with driver: Driver<ToggleState>) -> Disposable {
        driver.drive(rx.toggle)
    }
}
