//
//  ToggleWireframe.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import UIKit

final class ToggleWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "ToggleViewController", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ToggleViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = ToggleInteractor()
        let presenter = TogglePresenter(wireframe: self, view: moduleViewController, interactor: interactor)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension ToggleWireframe: ToggleWireframeInterface {}
