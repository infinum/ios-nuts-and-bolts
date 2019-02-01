//
//  Log+Details.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

extension Log {

    var overviewDataSource: [LogDetailsSection] {
        var sections: [LogDetailsSection] = []

        let section = LogDetailsSection()
        section.items.append(.subtitle("URL", request.url?.absoluteString))
        sections.append(section)

        if let method = request.httpMethod {
            section.items.append(.subtitle("Method", method))
        }
        if let responseStatus = response?.statusCode {
            section.items.append(.subtitle("Response status", String(responseStatus)))
        }
        if let startTime = startTime {
            let formatedDate = DateFormatter.localizedString(from: startTime, dateStyle: .medium, timeStyle: .medium)
            section.items.append(.subtitle("Request time", formatedDate))
        }
        if let endTime = endTime {
            let formatedDate = DateFormatter.localizedString(from: endTime, dateStyle: .medium, timeStyle: .medium)
            section.items.append(.subtitle("Response time", formatedDate))
        }
        if let durationString = durationString {
            section.items.append(.subtitle("Duration", durationString))
        }
        if let requestData = request.data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(requestData.count), countStyle: .memory)
            section.items.append(.subtitle("Request size", sizeString))
        }
        if let responseData = data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(responseData.count), countStyle: .memory)
            section.items.append(.subtitle("Response size", sizeString))
        }
        return sections
    }
}
