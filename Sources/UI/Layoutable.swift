//
//  autoLayoutable(.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public protocol Layoutable: UIView {

    /// Returns this view with 'translatesAutoresizingMaskIntoConstraints' set to false
    func autoLayoutable(preservesMargins: Bool?) -> Self

    /// Sets 'translatesAutoresizingMaskIntoConstraints' to false
    func makeAutoautoLayoutable(preservesMargins: Bool?)
}

public extension Layoutable {

    /// Returns this view with 'translatesAutoresizingMaskIntoConstraints' set to false
    func autoLayoutable() -> Self {
        return autoLayoutable(preservesMargins: nil)
    }

    /// Sets 'translatesAutoresizingMaskIntoConstraints' to false
    func makeAutoautoLayoutable() {
        makeAutoautoLayoutable(preservesMargins: nil)
    }
}

// MARK: - Conformances

extension UIView: Layoutable {}

public extension Layoutable where Self: UIView {

    func autoLayoutable(preservesMargins: Bool?) -> Self {
        makeAutoautoLayoutable(preservesMargins: preservesMargins)
        return self
    }

    func makeAutoautoLayoutable(preservesMargins: Bool?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let preservesMargins = preservesMargins {
            preservesSuperviewLayoutMargins = preservesMargins
        }
    }
}
