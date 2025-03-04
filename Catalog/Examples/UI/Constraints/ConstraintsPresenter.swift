//
//  ConstraintsPresenter.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright (c) 2023 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class ConstraintsPresenter {

    // MARK: - Private properties -

    private unowned let view: ConstraintsViewInterface
    private let wireframe: ConstraintsWireframeInterface

    // MARK: - Lifecycle -

    init(view: ConstraintsViewInterface, wireframe: ConstraintsWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension ConstraintsPresenter: ConstraintsPresenterInterface {

    func configure(with output: Constraints.ViewOutput) -> Constraints.ViewInput {
        return Constraints.ViewInput()
    }

}
