//
//  UIEdgeInsets+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 27.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    static func top(inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
    }

    static func bottom(inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

    static func left(inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
    }

    static func right(inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }
}
