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
        return createSections()
    }

}

private extension CatalogDataSource {

    func createSections() -> [CatalogSectionModel] {
        return [
            CatalogSectionModel(title: "UI", items: createUIItems()),
            CatalogSectionModel(title: "Rx", items: createRxItems()),
            CatalogSectionModel(title: "Networking", items: createNetworkingItems())
        ]
    }

}

private extension CatalogDataSource {

    func createUIItems() -> [Catalogizable.Type] {
        return [
            RatioTransitionViewController.self,
            RoundCornersViewController.self,
            UIViewModifiersViewController.self,
            ImageFromColorViewController.self,
            CatalogNavigationController.self,
            ToggleViewController.self
        ]
    }

}

private extension CatalogDataSource {

    func createRxItems() -> [Catalogizable.Type] {
        return [
            RxAlertExampleViewController.self,
            RxPagingViewController.self
        ]
    }

}

private extension CatalogDataSource {

    func createNetworkingItems() -> [Catalogizable.Type] {
        if #available(iOS 13, *) {
            return [
                NetworkingViewController.self,
                RxNetworkingViewController.self,
                NetworkingJapxViewController.self,
                CombineNetworkingViewController.self
            ]
        } else {
            return [
                NetworkingViewController.self,
                RxNetworkingViewController.self,
                NetworkingJapxViewController.self
            ]
        }
    }

}
