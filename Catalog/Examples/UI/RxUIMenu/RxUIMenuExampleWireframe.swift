//
//  RxUIMenuExampleWireframe.swift
//  Catalog
//
//  Created by Sven Svetina on 14.03.2023..
//  Copyright (c) 2023 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class RxUIMenuExampleWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "RxUIMenuExample", bundle: nil)

    // MARK: - Module setup -

    @available(iOS 15.0, *)
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: RxUIMenuExampleViewController.self)
        super.init(viewController: moduleViewController)

        let presenter = RxUIMenuExamplePresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension RxUIMenuExampleWireframe: RxUIMenuExampleWireframeInterface {}