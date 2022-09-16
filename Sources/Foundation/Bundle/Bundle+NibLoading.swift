//
//  Bundle+NibLoading.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public extension Bundle {

    @discardableResult
    func load<T: UIView>(viewOfType _: T.Type, owner: Any? = nil) -> T {
        let viewName = String(describing: T.self)
        return loadNibNamed(viewName, owner: nil, options: nil)!.first as! T
    }
}
