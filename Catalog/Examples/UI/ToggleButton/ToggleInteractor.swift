//
//  ToggleInteractor.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import RxSwift

final class ToggleInteractor {}

// MARK: - Extensions -

extension ToggleInteractor: ToggleInteractorInterface {

    func changeFollowStatus(from toggleState: ToggleState) -> Single<ToggleState> {
        Single.just(toggleState.toggleActivity()).delay(.seconds(1), scheduler: MainScheduler.instance)

    }
}
