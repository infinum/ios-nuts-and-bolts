//
//  UIViewModifiersViewController.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 08/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class UIViewModifiersViewController: UIViewController {

    @IBOutlet private weak var modifiedView: UIView!
    @IBOutlet private weak var shadowView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        modifiedView.borderColor = .yellow
        modifiedView.borderWidth = 2
        modifiedView.cornerRadius = 30

        shadowView.applyFigmaShadow(
            opacity: 0.5,
            offset: CGSize(width: 0, height: 4),
            blur: 8
        )
    }
}

extension UIViewModifiersViewController: Catalogizable {

    static var title: String {
        return "UIView Modifiers"
    }

    static var viewController: UIViewController {
        let storyboard = UIStoryboard(name: "UIViewModifiers", bundle: nil)
        return storyboard.instantiateViewController(ofType: UIViewModifiersViewController.self)
    }
}
