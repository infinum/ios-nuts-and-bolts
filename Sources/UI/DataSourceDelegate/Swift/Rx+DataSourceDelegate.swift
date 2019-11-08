//
//  Rx+DataSourceDelegate.swift
//  Catalog
//
//  Created by Filip Gulan on 03/11/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: TableDataSourceDelegate {

    var items: Binder<[TableCellItem]?> {
        return Binder(self.base) { dataSourceDelegate, items in
            dataSourceDelegate.items = items
        }
    }

    var sections: Binder<[TableSectionItem]?> {
        return Binder(self.base) { dataSourceDelegate, sections in
            dataSourceDelegate.sections = sections
        }
    }
}

public extension Reactive where Base: CollectionDataSourceDelegate {

    var items: Binder<[CollectionCellItem]?> {
        return Binder(self.base) { dataSourceDelegate, items in
            dataSourceDelegate.items = items
        }
    }

    var sections: Binder<[CollectionSectionItem]?> {
        return Binder(self.base) { dataSourceDelegate, sections in
            dataSourceDelegate.sections = sections
        }
    }
}
