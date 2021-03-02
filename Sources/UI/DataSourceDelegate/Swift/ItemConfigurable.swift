//
//  ItemConfigurable.swift
//  Catalog
//
//  Created by Martin Čolja on 02.03.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

protocol ItemConfigurable {
    associatedtype ConfigurationItem

    func configure(with item: ConfigurationItem)
}
