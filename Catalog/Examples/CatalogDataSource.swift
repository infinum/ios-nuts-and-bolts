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
        var sections = [
            CatalogSectionModel(title: "UI", items: createUIItems()),
            CatalogSectionModel(title: "Rx", items: createRxItems()),
            CatalogSectionModel(title: "Networking", items: createNetworkingItems())
        ]

        if #available(iOS 13, *) {
            sections.append(CatalogSectionModel(title: "Combine", items: createCombineItems()))
        }
        return sections
    }

}

private extension CatalogDataSource {

    func createUIItems() -> [Catalogizable.Type] {
        var items: [Catalogizable.Type] = [
            RatioTransitionViewController.self,
            RoundCornersViewController.self,
            UIViewModifiersViewController.self,
            ImageFromColorViewController.self,
            CatalogNavigationController.self,
            ToggleViewController.self,
            ConstraintsViewController.self,
            LineHeightViewController.self
        ]

        if #available(iOS 14.0, *) {
            items.append(contentsOf: createiOS14Items())
        }

        if #available(iOS 15.0, *) {
            items.append(RxUIMenuExampleViewController.self)
        }
        return items
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

@available(iOS 13, *)
private extension CatalogDataSource {
    func createCombineItems() -> [Catalogizable.Type] {
        return [
            CombinePagingViewController.self,
            CombineProgressableViewController.self,
            CombineAlertExampleViewController.self,
            CombineHapticFeedbackViewController.self
        ]
    }
}

@available(iOS 14, *)
private extension CatalogDataSource {

    func createiOS14Items() -> [Catalogizable.Type] {
        return [
            InputFieldViewController.self,
            KeyboardHandlerViewController.self
        ]
    }
}
