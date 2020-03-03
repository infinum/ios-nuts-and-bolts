//
//  LoggieRequest.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class Log: NSObject {

    static let dataDecoders: [DataDecoder] = [
        JSONDataDecoder(),
        PlainTextDataDecoder(),
        ImageDataDecoder(),
        DefaultDecoder()
    ]

    public var request: URLRequest
    public var response: HTTPURLResponse?
    public var data: Data?
    public var error: Error?

    public var startTime: Date?
    public var endTime: Date?

    public var duration: TimeInterval? {
        guard let start = startTime, let end = endTime else {
            return nil
        }
        return end.timeIntervalSince(start)
    }

    public var durationString: String? {
        guard let _duration = duration else {
            return nil
        }
        return String(format: "%dms", Int(_duration * 1000.0))
    }

    public init(request: URLRequest) {
        self.request = request
    }

    func logDetailsItem(with data: Data, contentType: String?) -> LogDetailsItem? {
        guard let dataDecoder = Log.dataDecoders.filter({ $0.canDecode(data, contentType: contentType) }).first else { return nil }
        return dataDecoder.decode(data, contentType: contentType)
    }

    func bodySection(with item: LogDetailsItem) -> LogDetailsSection {
        let section = LogDetailsSection(headerTitle: "Body")
        section.items.append(item)
        return section
    }
}

extension Log {

    public var shareRepresentation: String {
        var output: String = ""

        // MARK: - Overview -

        var overviewItems = [(String, String)]()

        if let url = request.url {
            overviewItems.append(("URL", url.absoluteString))
        }
        if let method = request.httpMethod {
            overviewItems.append(("Method", method))
        }
        if let responseStatus = response?.statusCode {
            overviewItems.append(("Response status", String(responseStatus)))
        }
        if let startTime = startTime {
            let formatedDate = DateFormatter.localizedString(from: startTime, dateStyle: .medium, timeStyle: .medium)
            overviewItems.append(("Request time", formatedDate))
        }
        if let endTime = endTime {
            let formatedDate = DateFormatter.localizedString(from: endTime, dateStyle: .medium, timeStyle: .medium)
            overviewItems.append(("Response time", formatedDate))
        }
        if let durationString = durationString {
            overviewItems.append(("Duration", durationString))
        }
        if let requestData = request.data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(requestData.count), countStyle: .memory)
            overviewItems.append(("Request size", sizeString))
        }
        if let responseData = data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(responseData.count), countStyle: .memory)
            overviewItems.append(("Response size", sizeString))
        }

        let overviewItemsString = overviewItems.map { String(format: "%@: %@", $0.0, $0.1) }.joined(separator: "\n")
        output += _string(for: "Overview", value: overviewItemsString)

        // MARK: - REQUEST -

        output += _formattedSectionTitle("Request")

        if let headers = request.allHTTPHeaderFields {
            output += _string(for: "Headers", value: headers.shareRepresentation)
        }

        if let url = request.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            let queryParamsString: String = queryItems
                .map({ queryItem -> String in
                    return String(format: "%@: %@", queryItem.name, queryItem.value ?? "")
                })
                .joined(separator: "\n")

            output += _string(for: "Query params", value: queryParamsString)
        }

        if let body = request.data, let jsonString = body.formattedJsonString {
            output += _string(for: "BODY", value: jsonString)
        }

        // MARK: - RESPONSE -

        output += _formattedSectionTitle("Response")

        if let headers = response?.allHeaderFields as? [String: String] {
            output += _string(for: "Headers", value: headers.shareRepresentation)
        }

        if let body = data, let jsonString = body.formattedJsonString {
            output += _string(for: "Body", value: jsonString)
        }

        return output
    }

    private func _string(for title: String, value: String) -> String {
        return String(format: "\t%@:\n-----------------------\n%@\n\n", title, value)
    }

    private func _formattedSectionTitle(_ title: String) -> String {
        let line = "--------------------------------"
        return [line, title, line].joined(separator: "\n") + "\n\n"
    }
}


fileprivate extension Dictionary where Key == String, Value == String {

    var shareRepresentation: String {
        return self.map { String(format: "%@: %@", $0.key, $0.value) }.joined(separator: "\n")
    }
}
