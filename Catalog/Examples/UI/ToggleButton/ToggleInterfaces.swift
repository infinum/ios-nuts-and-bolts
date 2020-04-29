//
//  ToggleInterfaces.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ToggleViewInterface: ViewInterface {}

protocol TogglePresenterInterface: PresenterInterface {
    func configure(with output: Toggle.ViewOutput) -> Toggle.ViewInput
}

protocol ToggleInteractorInterface: InteractorInterface {
    func changeFollowStatus(from toggleState: ToggleState) -> Single<ToggleState>
}

protocol ToggleWireframeInterface: WireframeInterface {}

enum Toggle {
    struct ViewOutput {
        let currentState: Signal<ToggleState>
    }

    struct ViewInput {
        let newState: Driver<ToggleState>
    }
}
