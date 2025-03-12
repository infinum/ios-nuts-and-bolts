//
//  ComponentConfigurable.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

/// A common protocol for components that can be loaded through their configurators.

/// The configurator which implements the protocol needs to supply a concrete view for which it's used.
protocol ComponentConfigurable {
    var view: UIView { get }
}
