//
//  Log+RequestDetails.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

extension Log {

    var requestDataSource: [LogDetailsSection] {
        var sections: [LogDetailsSection] = []

        if let headers = request.allHTTPHeaderFields {
            let headersSection = LogDetailsSection(headerTitle: "Headers")
            sections.append(headersSection)

            headersSection.items = headers.map({ (key, value) -> LogDetailsItem in
                return LogDetailsItem.subtitle(key, value)
            })
        }

        if let url = request.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            let queryParamsSection = LogDetailsSection(headerTitle: "Query params")
            sections.append(queryParamsSection)

            queryParamsSection.items = queryItems.map({ queryItem -> LogDetailsItem in
                return LogDetailsItem.subtitle(queryItem.name, queryItem.value)
            })
        }

        if let body = request.data {
            let contentType = request.value(forHTTPHeaderField: "Content-Type")
            let item = logDetailsItem(with: body, contentType: contentType)
            if let item = item {
                sections.append(bodySection(with: item))
            }
        }

        return sections
    }
}
