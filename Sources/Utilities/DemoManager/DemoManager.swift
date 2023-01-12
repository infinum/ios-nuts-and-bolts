//
//  DemoManager.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import OHHTTPStubs

public protocol DemoManaging {
    var isRunning: Bool { get }
    func start()
    func stop()
    func reset()
}

public final class DemoManager {

    // MARK: - Private properties -

    private var isEnabled = false {
        didSet { isEnabled ? setupDemoEnvironment() : reset() }
    }

    // MARK: - Singleton -

    static let instance = DemoManager()
    private init() {}
}

// MARK: - Extensions -

// MARK: - DemoManaging conformance

extension DemoManager: DemoManaging {

    public var isRunning: Bool { isEnabled }

    public func start() {
        isEnabled = true
    }

    public func stop() {
        isEnabled = false
    }

    public func reset() {
        DependencyContainer.Registrations.reset()
        // Remove stubs if you're using them
    }
}

// MARK: - Helpers

private extension DemoManager {

    func setupDemoEnvironment() {
        mockDependencies()
        // Also setup stubs if you're using them
    }

    func mockDependencies() {
        // Mock any dependecy you need
        DependencyContainer.complexSigletonClass.register(factory: { MockComplexSingletonClass() })
    }
}

// MARK: - Stubbing -

private extension DemoManager {

    func stubResponse(
        containing urlPart: String,
        queryParamPart: String? = nil,
        requiredHeaderValues: String?...,
        bodyPart: [String]? = nil,
        method: HTTPMethod? = nil,
        statusCode: Int32 = 200,
        from fileName: String? = nil,
        responseDelay: DispatchTimeInterval
    ) {
        stub(
            condition: { (request: URLRequest) -> Bool in
                // Method
                if let method = method?.rawValue.uppercased(), request.httpMethod?.uppercased() != method { return false }

                // URL, query
                if !(request.url?.absoluteString.contains(urlPart) ?? false) { return false }
                if let part = queryParamPart, !(request.url?.absoluteString.contains(part) ?? false) { return false }

                // Body
                if
                    let parts = bodyPart,
                    let data = request.ohhttpStubs_httpBody,
                    let body = String(data: data, encoding: .utf8)
                {
                    let bodyPartsPresent = parts
                        .map { body.contains($0) }
                        .contains(true)
                    if !bodyPartsPresent { return false }
                }

                // Headers
                let headers = request.allHTTPHeaderFields ?? [:]
                let headersOk = requiredHeaderValues
                    .compactMap { $0 }
                    .map { headerValue in
                        return headers.contains { $0.value == headerValue }
                    }
                    .allSatisfy { $0 }

                return headersOk
            },
            response: { _ -> HTTPStubsResponse in
                guard let fileName = fileName else {
                    return HTTPStubsResponse(data: Data(), statusCode: statusCode, headers: nil)
                }

                let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""

                let headers = fileName == "locations"
                ? ["Content-Type": "text/html;charset=UTF-8"]
                : ["Content-Type": "application/json"]

                if !Thread.isMainThread { sleep(1) }

                return fixture(filePath: path, status: statusCode, headers: headers)
            }
        )
    }
}

// MARK: - JSON Filenames -

private extension DemoManager {

    enum Files {
    }
}

// MARK: - String helper -

private extension String {

    /// Used for stripping path parameters out of URL string.
    /// *stubResponse* method matches the URL of a stubbed request to a registered *path* string
    /// As we don't control the parameters used in stubbed request,  best guess is to have everything stripped from the first path parameter to the end of the URL
    var paramStripped: String {
        guard let index = self.firstIndex(of: "%") else { return self }
        return String(self[..<index])
    }
}
