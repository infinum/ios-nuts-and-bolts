//
//  URLResponse+LogRepresentation.swift
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation

public extension HTTPURLResponse {
    
    struct LogLevel: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let headers = LogLevel(rawValue: 1 << 0)
        public static let body = LogLevel(rawValue: 1 << 1)
        
        public static let all: LogLevel = [.headers, .body]
    }
    
    /// Logs response info into console with specifed level. Body will be serialized as JSON.
    /// - Parameter level: Parts of response to log
    func log(_ level: LogLevel, data: Data? = nil) -> String {
        let separatorLine = "---------------------"
        var output: String = [separatorLine, "🟢 Response", separatorLine].joined(separator: "\n")
        
        let addSeparatorToOutput: () -> Void = {
            if !output.hasSuffix("\n") { output.append("\n") }
            output.append(separatorLine)
        }
        
        let addInfoStringToOutput: (String?) -> Void = {
            guard let value = $0 else { return }
            if !output.hasSuffix("\n") { output.append("\n") }
            output.append(value)
        }
        
        addInfoStringToOutput(getBasicRepresentation())

        if level.contains(.headers) {
            addInfoStringToOutput(getHeadersRepresentation())
        }
        
        if level.contains(.body), let data = data {
            addInfoStringToOutput(getBodyRepresentation(for: data))
        }
        
        addSeparatorToOutput()
        return output.trimmingCharacters(in: .newlines)
    }
}

private extension HTTPURLResponse {
    
    func getBasicRepresentation() -> String {
        var overviewItems = [(String, String)]()
        if let url = url {
            overviewItems.append(("URL", url.absoluteString))
        }
        overviewItems.append(("Response status", String(statusCode)))
        return overviewItems
            .map { String(format: "%@: %@", $0.0, $0.1) }
            .joined(separator: "\n")
    }
    
    func getHeadersRepresentation() -> String? {
        guard !allHeaderFields.isEmpty else { return nil }
        let headersValues = allHeaderFields
            .map { "  \"\($0)\": \"\($1)\"" }
            .joined(separator: ",\n")
        return ["Headers: [", headersValues, "]"].joined(separator: "\n")
    }

    func getBodyRepresentation(for data: Data) -> String? {
        let bodyString = (try? JSONSerialization.jsonObject(with: data, options: []))
            .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
            .flatMap { String(data: $0, encoding: .utf8) }
        guard let unwrappedBody = bodyString, !unwrappedBody.isBlank else { return nil }
        return ["Body:", unwrappedBody].joined(separator: "\n")
    }
}
