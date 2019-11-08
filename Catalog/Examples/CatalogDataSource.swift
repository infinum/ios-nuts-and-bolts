//
//  CatalogDataSource.swift
//
//  Created by Filip Gulan on 12/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

struct CatalogSectionModel {
    let title: String
    let items: [Catalogizable.Type]
}

class CatalogDataSource {

    var sections: [CatalogSectionModel] {
        return _sections()
    }

}

private extension CatalogDataSource {

    func _sections() -> [CatalogSectionModel] {
        return [
            CatalogSectionModel(title: "UI", items: _uiItems()),
            CatalogSectionModel(title: "Rx", items: _rxItems()),
            CatalogSectionModel(title: "Networking", items: _networkingItems())
        ]
    }

}

private extension CatalogDataSource {

    func _uiItems() -> [Catalogizable.Type] {
        return [
            RatioTransitionViewController.self,
            RoundCornersViewController.self,
            UIViewModifiersViewController.self,
            ImageFromColorViewController.self,
            CatalogNavigationController.self
        ]
    }

}

private extension CatalogDataSource {

    func _rxItems() -> [Catalogizable.Type] {
        return [
            RxAlertExampleViewController.self,
            RxPagingViewController.self
        ]
    }

}

private extension CatalogDataSource {

    func _networkingItems() -> [Catalogizable.Type] {
        return [
            NetworkingViewController.self,
            RxNetworkingViewController.self
        ]
    }

}
