//
//  WithoutBackViewController.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 29/08/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class WithoutBackViewController: UIViewController {

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }

    @IBAction private func navigateNext() {
        _navigate(to: .next)
    }

    @IBAction private func navigateBack() {
        _navigate(to: .back)
    }

}

private extension WithoutBackViewController {

    enum NavigationOptions {
        case next, back
    }

    func _navigate(to options: NavigationOptions) {
        switch options {
        case .next:
            let interactiveStoryboard = UIStoryboard(name: "InteractiveNavigationExample", bundle: nil)
            let nextViewController = interactiveStoryboard.instantiateViewController(ofType: BasicViewController.self)
            navigationController?.pushViewController(nextViewController, animated: true)
        case .back:
            navigationController?.popViewController(animated: true)
        }
    }
}
