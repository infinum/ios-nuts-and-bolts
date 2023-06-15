//
//  UIView+BorderColor.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    func animateBorderColor(toColor color: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = color.cgColor
        animation.duration = duration

        layer.add(animation, forKey: "borderColor")
        layer.borderColor = color.cgColor
    }
}
