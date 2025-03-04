//
//  RxUIMenuExampleInterfaces.swift
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

protocol RxUIMenuExampleWireframeInterface: WireframeInterface {
}

protocol RxUIMenuExampleViewInterface: ViewInterface {
}

protocol RxUIMenuExamplePresenterInterface: PresenterInterface {
    func configure(with output: RxUIMenuExample.ViewOutput) -> RxUIMenuExample.ViewInput
}

enum RxUIMenuExample {

    struct ViewOutput {
    }

    struct ViewInput {
    }

}
