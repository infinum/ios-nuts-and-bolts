//
//  BasicViewController.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 29/08/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeButton.isHidden = (navigationController?.viewControllers.count ?? 0) > 1
    }

    // MARK: - Actions -

    @IBAction private func navigateNextActionHandler() {
        navigate(to: .basic)
    }

    @IBAction private func navigateNextWithoutBackButtonActionHandler() {
        navigate(to: .withoutBackButton)
    }

    @IBAction private func closeActionHandler() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private methods -

private extension BasicViewController {

    enum NavigationOption {
        case basic, withoutBackButton
    }

    func navigate(to option: NavigationOption) {
        let interactiveStoryboard = UIStoryboard(name: "InteractiveNavigationExample", bundle: nil)
        let nextViewController: UIViewController
        switch option {
        case .basic:
            nextViewController = interactiveStoryboard.instantiateViewController(ofType: BasicViewController.self)
        case .withoutBackButton:
            nextViewController = interactiveStoryboard.instantiateViewController(ofType: WithoutBackViewController.self)
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
