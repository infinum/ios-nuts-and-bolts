//
//  TogglePresenter.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRelay

final class TogglePresenter {

    // MARK: - Private properties -

    private unowned let view: ToggleViewInterface
    private let wireframe: ToggleWireframeInterface
    private let interactor: ToggleInteractorInterface

    // MARK: - Lifecycle -

    init(wireframe: ToggleWireframeInterface, view: ToggleViewInterface, interactor: ToggleInteractorInterface) {
        self.wireframe = wireframe
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - Extensions -

extension TogglePresenter: TogglePresenterInterface {

    func configure(with output: Toggle.ViewOutput) -> Toggle.ViewInput {
        let progressRelay = PublishRelay<ToggleState>()

        let tap = output.currentState
            .filter { $0 != .inProgress }
            .do(onNext: { _ in progressRelay.accept(.inProgress) })
            .flatMapLatest { [unowned interactor] in
                interactor
                    .changeFollowStatus(from: $0)
                    .asDriver(onErrorJustReturn: $0)
            }

        let newState = Driver.merge(progressRelay.asDriver(onErrorDriveWith: .empty()), tap)
        return Toggle.ViewInput(newState: newState)
    }
}
