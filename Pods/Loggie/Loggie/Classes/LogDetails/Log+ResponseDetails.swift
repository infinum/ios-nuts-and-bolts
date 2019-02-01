//
//  Log+ResponseDetails.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

extension Log {

    var responseDataSource: [LogDetailsSection] {
        var sections: [LogDetailsSection] = []
        if let error = error as NSError? {
            let errorSection = LogDetailsSection(headerTitle: "Error")
            sections.append(errorSection)

            errorSection.items = [
                LogDetailsItem.subtitle("Code", String(error.code)),
                LogDetailsItem.subtitle("Description", error.localizedDescription),
                LogDetailsItem.subtitle("Failure reason", error.localizedFailureReason),
                LogDetailsItem.subtitle("Recovery options", error.localizedRecoveryOptions?.joined(separator: ", ")),
                LogDetailsItem.subtitle("Failure", error.localizedRecoverySuggestion)
            ]

            let userInfo = LogDetailsSection(headerTitle: "User info")
            sections.append(userInfo)

            userInfo.items = error.userInfo.compactMap({ (arg) -> LogDetailsItem? in
                #if swift(>=4.0)
                    let key = arg.key
                #else
                    guard let key = arg.key as? String else { return nil }
                #endif
                return LogDetailsItem.subtitle(key, String(describing: arg.value))
            })

        } else {
            if let headers = response?.allHeaderFields as? [String: String] {
                let headersSection = LogDetailsSection(headerTitle: "Headers")
                sections.append(headersSection)

                headersSection.items = headers.map({ (key, value) -> LogDetailsItem in
                    return LogDetailsItem.subtitle(key, value)
                })
            }

            if let body = data {
                let contentType = response?.allHeaderFields["Content-Type"] as? String
                let item = logDetailsItem(with: body, contentType: contentType)
                if let item = item {
                    sections.append(bodySection(with: item))
                }
            }
        }

        return sections
    }
}
