//
//  DependencyManager.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public final class DependencyManager {

    // MARK: - Singleton -

    static let instance = DependencyManager()
    private init() { }
}

// MARK: - Extensions -

// MARK: - Concrete dependency resolving

public extension DependencyManager {

    var exampleClass: ExampleClassing {
        DependencyContainer.exampleClass()
    }

    var complexSingletonClass: ComplexSingletonClassing {
        DependencyContainer.complexSigletonClass()
    }
}
