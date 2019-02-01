//
//  CatalogItem.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

struct CatalogItem {
    let title: String
    let navigateTo: (CatalogItem) -> UIViewController
}
