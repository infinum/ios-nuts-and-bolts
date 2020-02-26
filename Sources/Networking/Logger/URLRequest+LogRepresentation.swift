//
//  URLRequest+LogRepresentation.swift
//  Networking
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation

extension URLRequest {
    
    struct LogLevel: OptionSet {
        let rawValue: Int
        
        static let headers = LogLevel(rawValue: 1 << 0)
        static let queryParams = LogLevel(rawValue: 1 << 1)
        static let body = LogLevel(rawValue: 1 << 2)
        
        static let all: LogLevel = [.headers, .queryParams, .body]
    }
    
    func log(_ level: LogLevel) -> String {
        let separatorLine = "---------------------"
        var output: String = [separatorLine, "🔵 Request", separatorLine].joined(separator: "\n")
        
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
        
        if level.contains(.queryParams) {
            addInfoStringToOutput(getQueryParamsRepresentation())
        }
        
        if level.contains(.body) {
            addInfoStringToOutput(getBodyRepresentation())
        }
        addSeparatorToOutput()
        return output.trimmingCharacters(in: .newlines)
    }
}

private extension URLRequest {
    
    func getBasicRepresentation() -> String {
        var overviewItems = [(String, String)]()

        if let url = url {
            overviewItems.append(("URL", url.absoluteString))
        }
        
        if let method = httpMethod {
            overviewItems.append(("Method", method))
        }
        
        if let requestData = data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(requestData.count), countStyle: .memory)
            overviewItems.append(("Request size", sizeString))
        }
        
        return overviewItems
            .map { String(format: "%@: %@", $0.0, $0.1) }
            .joined(separator: "\n")
    }
    
    func getHeadersRepresentation() -> String? {
        guard let headers = allHTTPHeaderFields, !headers.isEmpty else {
            return nil
        }
        let headersValues = headers
            .map { "  \"\($0)\": \"\($1)\"" }
            .joined(separator: ",\n")
        return ["Headers: [", headersValues, "]"].joined(separator: "\n")
    }
    
    func getQueryParamsRepresentation() -> String? {
        guard
            let url = url,
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        else { return nil }
        let queryItemValues = queryItems
            .map { "  \($0.name) = \($0.value ?? "")" }
            .joined(separator: "\n")
        return ["Query items: [", queryItemValues, "]"].joined(separator: "\n")
    }
    
    func getBodyRepresentation() -> String? {
        let bodyString = data
            .flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) }
            .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
            .flatMap { String(data: $0, encoding: .utf8) }
        guard let unwrappedBody = bodyString, !unwrappedBody.isBlank else { return nil }
        return ["Body:", unwrappedBody].joined(separator: "\n")
    }
}

private extension URLRequest {

    var data: Data? {
        if let body = httpBody {
            return body
        } else if let stream = httpBodyStream {
            let body = NSMutableData()
            var buffer = [UInt8](repeating: 0, count: 4096)
            stream.open()
            while stream.hasBytesAvailable {
                let length = stream.read(&buffer, maxLength: 4096)
                if length == 0 {
                    break
                } else {
                    body.append(&buffer, length: length)
                }
            }
            return body as Data
        }
        return nil
    }
}
