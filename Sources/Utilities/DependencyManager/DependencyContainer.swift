//
//  DependencyContainer.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//
// https://github.com/hmlongco/Factory

import Foundation
import Factory

public final class DependencyContainer: SharedContainer {
    static let exampleClass = Factory { ExampleClass() as ExampleClassing }
    static let complexSigletonClass = Factory(scope: .singleton) { ComplexSingletonClass(exampleClass: exampleClass()) as ComplexSingletonClassing }
}

// MARK: - Example protocols

public protocol ExampleClassing {
    var exampleString: String? { get set }
}

public protocol ComplexSingletonClassing {
    var exampleClass: ExampleClassing { get }
}

// MARK: - Example classes

public final class ExampleClass: ExampleClassing {
    public var exampleString: String?

    init(exampleString: String? = nil) {
        self.exampleString = exampleString
    }
}

public final class ComplexSingletonClass: ComplexSingletonClassing {

    // MARK: - Public properties -

    public let exampleClass: ExampleClassing

    // MARK: - Init -

    public init(exampleClass: ExampleClassing) {
        self.exampleClass = exampleClass
    }
}
