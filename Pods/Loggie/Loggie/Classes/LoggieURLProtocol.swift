//
//  LoggieURLProtocol.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieURLProtocol: URLProtocol {

    private var dataTask: URLSessionDataTask?

    private static let HeaderKey = "Loggie"

    fileprivate var loggieManager = LoggieManager.shared
    private var log: Log?

    // MARK: - URLProtocol

    public override class func canInit(with request: URLRequest) -> Bool {
        guard property(forKey: LoggieURLProtocol.HeaderKey, in: request) == nil else {
            return false
        }
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }

    public override func startLoading() {
        let canonicalRequest = LoggieURLProtocol.canonicalRequest(for: request)
        let mutableRequest = (canonicalRequest as NSURLRequest).mutableCopy() as! NSMutableURLRequest

        LoggieURLProtocol.setProperty(true, forKey: LoggieURLProtocol.HeaderKey, in: mutableRequest)

        log = Log(request: mutableRequest as URLRequest)
        log?.startTime = Date()

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        dataTask = session.dataTask(with: (mutableRequest as URLRequest), completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }

            self.log?.endTime = Date()
            self.log?.error = error
            self.log?.data = data
            self.log?.response = response as? HTTPURLResponse
            self.saveLog()

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            self.client?.urlProtocolDidFinishLoading(self)
        })
        dataTask?.resume()
    }

    public override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    private func saveLog() {
        guard let log = log else { return }
        loggieManager.add(log)
    }
}

extension LoggieURLProtocol: URLSessionDelegate, URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential? = nil

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if
                let serverTrustPolicy = loggieManager.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }
        completionHandler(disposition, credential)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential? = nil

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if
                let serverTrustPolicy = loggieManager.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .rejectProtectionSpace
            } else if let authentication = loggieManager.authentication, let authParams = authentication() {
                credential = URLCredential(user: authParams.username, password: authParams.password, persistence: .none)
                disposition = .useCredential
            }
        }
        completionHandler(disposition, credential)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        completionHandler(request)
    }
}
