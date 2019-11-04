//
//  Pokemon.swift
//  Catalog
//
//  Created by Filip Gulan on 13/09/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

struct Pokemon: Codable, Comparable, Hashable {
    let name: String
    let url: String?

    static func < (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.name < rhs.name
    }
}

struct PokemonsPage: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Pokemon]
}
