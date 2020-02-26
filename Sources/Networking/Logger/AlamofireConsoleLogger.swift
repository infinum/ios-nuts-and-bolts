//
//  AlamofireConsoleLogger.swift
//  Networking
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireConsoleLogger: EventMonitor {
    
    let queue: DispatchQueue = DispatchQueue(label: "com.infinum.networking.logger")
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
    
    func requestDidResume(_ request: Request) {
        guard !joinLogs, let urlRequest = request.request else { return }
        let requestLogLevel = self.requestLogLevel
        queue.async { print(urlRequest.log(requestLogLevel)) }
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        didParseResponse(response.map { _ in () }, request: request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        didParseResponse(response.map { _ in () }, request: request)
    }
    
    private func didParseResponse(_ response: DataResponse<Void, AFError>, request: DataRequest) {
        let joinLogs = self.joinLogs
        let requestLogLevel = self.requestLogLevel
        let responseLogLevel = self.responseLogLevel
        queue.async {
            if joinLogs, let urlRequest = request.request {
                print(urlRequest.log(requestLogLevel))
            }
            if let httpResponse = response.response {
                print(httpResponse.log(responseLogLevel, data: response.data))
            }
        }
    }
    
}
