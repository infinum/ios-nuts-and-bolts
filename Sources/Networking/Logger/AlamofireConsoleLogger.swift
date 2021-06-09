//
//  AlamofireConsoleLogger.swift
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Alamofire EventMonitor conformance for logging requests and responses
public final class AlamofireConsoleLogger {
    
    public let queue = DispatchQueue(label: "com.infinum.networking.logger")
    private let joinLogs: Bool
    private let requestLogLevel: URLRequest.LogLevel
    private let responseLogLevel: HTTPURLResponse.LogLevel
    
    /// Creates Alamofire Logger which logs requests and responses to console
    /// - Parameters:
    ///   - joinLogs: Log request together with response. Request won't be printed until response arrives
    ///   - requestLogLevel: Request log level. Possible values `.headers`, `.body`, `.queryParams`. `.all` default.
    ///   - responseLogLevel: Response log level. Possible values `.headers`, `.body`. `.all` default.
    init(
        joinLogs: Bool = false,
        requestLogLevel: URLRequest.LogLevel = .all,
        responseLogLevel: HTTPURLResponse.LogLevel = .all
    ) {
        self.joinLogs = joinLogs
        self.requestLogLevel = requestLogLevel
        self.responseLogLevel = responseLogLevel
    }
}

// MARK: - EventMonitor interface

extension AlamofireConsoleLogger: EventMonitor {
    
    // Log each start of request and print them only in case if logs aren't joined
    public func requestDidResume(_ request: Request) {
        guard !joinLogs, let urlRequest = request.request else { return }
        queue.async { [requestLogLevel] in print(urlRequest.log(requestLogLevel)) }
    }
    
    // Log response in case client didn't expect any kind of object to decode
    public func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        didParseResponse(response.map { _ in () }, request: request)
    }
    
    // Log response in case client did expect some kind of object to decode
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        didParseResponse(response.map { _ in () }, request: request)
    }
}

// MARK: - Private helpers

private extension AlamofireConsoleLogger {
    
    private func didParseResponse(_ response: DataResponse<Void, AFError>, request: DataRequest) {
        queue.async { [joinLogs, requestLogLevel, responseLogLevel] in
            if joinLogs, let urlRequest = request.request {
                print(urlRequest.log(requestLogLevel))
            }
            if let httpResponse = response.response {
                print(httpResponse.log(responseLogLevel, data: response.data))
            }
        }
    }
}
