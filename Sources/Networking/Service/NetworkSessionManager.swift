//
//  NetworkSessionManager.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Alamofire

public protocol NetworkSessionManaging: AnyObject {
    var authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>? { get set }
    var session: Alamofire.Session { get }
}

/// Use it to store all kind of session related info like authorization adapter, networking session,
/// currently logged in user, etc.
public final class NetworkSessionManager: NetworkSessionManaging {

    // MARK: - Public properties

    /// Shared networking manager
    static let `default`: NetworkSessionManaging = NetworkSessionManager()
    private init() { }

    /// Authorization interceptor will prefix an authorization header to all requests
    public var authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>?

    /// App-default version of `Alamofire.Session`
    public private(set) lazy var session: Session = { createSession(with: defaultConfiguration) }()
}

// MARK: - Private inits

private extension NetworkSessionManager {

    // Set up custom session configuration, for example: Loggie usage.
    var defaultConfiguration: URLSessionConfiguration {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        return configuration
    }

    // In case you need a SSL pinning here is the place to do it.
    var trustManager: ServerTrustManager {
        // Here you can even set the DisabledTrustEvaluator for URLs
        let serverTrustEvaluators: [String: Alamofire.ServerTrustEvaluating] = [:]
        return ServerTrustManager(evaluators: serverTrustEvaluators)
    }

    // Here you can add custom event monitors like loggers.
    var eventMonitors: [Alamofire.EventMonitor] {
        var monitors = [Alamofire.EventMonitor]()
        #if DEBUG
        monitors.append(AlamofireConsoleLogger())
        #endif
        return monitors
    }
}

// MARK: - Session configuration

public extension NetworkSessionManager {

    func createSession(with configuration: URLSessionConfiguration) -> Session {
        // Queue that is passed to the Session as a `rootQueue` *has* to be serial
        let queue: DispatchQueue = .init(
            label: "com.infinum.catalog.network-service-operation-queue",
            qos: DispatchQoS.default,
            attributes: [],
            autoreleaseFrequency: .inherit,
            target: nil
        )
        return .init(
            configuration: configuration,
            rootQueue: queue,
            serverTrustManager: trustManager,
            eventMonitors: eventMonitors
        )
    }
}
