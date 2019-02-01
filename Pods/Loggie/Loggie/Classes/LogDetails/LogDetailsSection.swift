//
//  LogDetailsSection.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

enum LogDetailsItem {

    case subtitle(String?, String?)
    case text(String?)
    case image(UIImage?)
}

class LogDetailsSection: NSObject {

    var headerTitle: String?
    var footerTitle: String?

    var items: [LogDetailsItem] = []

    init(headerTitle: String? = nil, footerTitle: String? = nil) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}
