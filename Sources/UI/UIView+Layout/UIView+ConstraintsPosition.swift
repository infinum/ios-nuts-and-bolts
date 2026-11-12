//
//  UIView+ConstraintsPosition.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    /// Creates and returns constraints that align self with specified view's center point. Optional offset. Returned constraints have to be activated.
    func constraintsWhichCenter(view: LayoutGuideInterface, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y)
        ]
    }

    /// Creates and returns constraints that align self with specified view's center point. Optional offset. Returned constraints have to be activated.
    func constraintsWhichCenterSuperview(offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return constraintsWhichCenter(view: superview, offset: offset)
    }
}
