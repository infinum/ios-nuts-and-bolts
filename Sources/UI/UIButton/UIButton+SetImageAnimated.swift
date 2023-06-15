//
//  UIButton+SetImageAnimated.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public extension UIButton {

    func setImageAnimated(image: UIImage?, state: UIControl.State = .normal, duration: TimeInterval = 0.3) {
        UIView.transition(
            with: self,
            duration: duration,
            options: [.transitionCrossDissolve, .allowUserInteraction]
        ) {
            self.setImage(image, for: state)
        }
    }
}
