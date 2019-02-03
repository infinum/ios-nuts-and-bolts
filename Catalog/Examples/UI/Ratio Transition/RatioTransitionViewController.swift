//
//  RatioTransitionViewController.swift
//  Catalog
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class RatioTransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}

extension RatioTransitionViewController: Catalogizable {

    static var title: String {
        return "Ratio Transition"
    }
    
    static var viewController: UIViewController {
        return RatioTransitionViewController()
    }
    
}
