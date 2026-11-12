//
//  Page.swift
//  Catalog
//
//  Created by Antonijo Bezmalinovic on 10.01.2023..
//  Copyright (c) 2021 Infinum. All rights reserved.
//

import Foundation

/// Defines template for page
protocol Page where Item: Pageable {

    /// Constraint results to types that conform to Pageable
    associatedtype Item

    var count: Int { get }
    var next: URL? { get }
    var previous: URL? { get }
    var pages: Int { get }
    var page: Int { get }
    var results: [Item] { get }
}

extension Page {
    
    var pages: Int {
        return 0
    }
    
    var page: Int {
        return 0
    }
    
    var next: URL? {
        return nil
    }
    
    var previous: URL? {
        return nil
    }
}
