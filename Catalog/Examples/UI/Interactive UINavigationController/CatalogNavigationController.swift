//
//  CatalogNavigationController.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 29/08/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift

class CatalogNavigationController: InteractiveNavigationController {

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - Overrides -

extension CatalogNavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let shouldAddBackButton = !viewControllers.isEmpty && viewController.navigationItem.leftBarButtonItem == nil
        if shouldAddBackButton {
            viewController.navigationItem.leftBarButtonItem = _createAndHandleNavigationBackButton()
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Private methods -

private extension CatalogNavigationController {

    func _createAndHandleNavigationBackButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: "back-arrow"),
            style: .plain,
            target: self,
            action: #selector(_navigateBackAnimated)
        )
    }

    @objc 
    func _navigateBackAnimated() {
        self.popViewController(animated: true)
    }
}

extension CatalogNavigationController: Catalogizable {

    static var title: String {
        return "Interactive push navigation"
    }

    static var viewController: UIViewController {
        let basicViewController = UIStoryboard(name: "InteractiveNavigationExample", bundle: nil).instantiateInitialViewController()!
        return CatalogNavigationController(rootViewController: basicViewController)
    }

    static var presentationStyle: PresentationStyle {
        return .present
    }
}
