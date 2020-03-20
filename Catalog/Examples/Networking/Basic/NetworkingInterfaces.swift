//
//  NetworkingInterfaces.swift
//
//  Created by Filip Gulan on 25/04/2019.
//  Copyright (c) 2019 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Alamofire

protocol NetworkingWireframeInterface: WireframeInterface {
}

protocol NetworkingViewInterface: ViewInterface {
}

protocol NetworkingPresenterInterface: PresenterInterface {
}

protocol NetworkingInteractorInterface: InteractorInterface {
    func login(email: String, password: String, completion: @escaping (AFResult<Void>) -> Void)
}
