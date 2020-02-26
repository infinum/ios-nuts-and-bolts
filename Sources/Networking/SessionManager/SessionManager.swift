//
//  SessionManager.swift
//  Catalog
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public class SessionManager {

    // MARK: - Public properties

    /// Shared networking manager
    public static let `default` = SessionManager()
    
    /// Authorization adapter will be prefixed to all requests
    public var authorizationAdapter: RequestInterceptor?
    
    /// Alamofire Session storage
    public lazy var session: Session = {
        let policyManager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [:])
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        let adapter = Adapter { [weak self] (request, session, completion) in
            guard let authorizationAdapter = self?.authorizationAdapter else {
                completion(.success(request))
                return
            }
            authorizationAdapter.adapt(request, for: session, completion: completion)
        }
        return Session(
            configuration: configuration,
            interceptor: adapter,
            serverTrustManager: policyManager,
            eventMonitors: eventMonitors
        )
    }()
    
    // MARK: - Private properties
    
    private var eventMonitors: [EventMonitor] {
        var monitors = [EventMonitor]()
        #if DEBUG
        monitors.append(AlamofireConsoleLogger())
        #endif
        return monitors
    }
    
    private init() { }
}
