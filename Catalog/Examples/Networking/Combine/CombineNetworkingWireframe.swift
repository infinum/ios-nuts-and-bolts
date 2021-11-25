//
//  CombineNetworkingWireframe.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.10.2021..
//  Copyright (c) 2021 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

@available(iOS 13, *)
final class CombineNetworkingWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "CombineNetworking", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: CombineNetworkingViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = CombineNetworkingInteractor()
        let presenter = CombineNetworkingPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

@available(iOS 13, *)
extension CombineNetworkingWireframe: CombineNetworkingWireframeInterface {
}