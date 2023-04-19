//
//  LoggieManager.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

extension Notification.Name {
    static let LoggieDidUpdateLogs = Notification.Name("co.infinum.loggie-did-update-logs")
}

public class LoggieAuthentication: NSObject {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

@objc public protocol LoggieClientCertificateDelegate: AnyObject {
    func clientCertificate(forChallenge challenge: URLAuthenticationChallenge, inSession session: URLSession) -> URLCredential?
}

public typealias AuthenticationBlock = (() -> (LoggieAuthentication?))

internal protocol LogsDataSourceDelegate: AnyObject {
    func clearLogs()
}

public class LoggieManager: NSObject, LogsDataSourceDelegate {

    @objc(sharedManager)
    public static let shared = LoggieManager()

    @objc
    public weak var clientCertificateDelegate: LoggieClientCertificateDelegate? = nil
    
    @objc
    public var serverTrustPolicyManager: ServerTrustPolicyManager? = nil
    public var authentication: AuthenticationBlock? = nil

    public private(set) var logs = [Log]() {
        didSet {
            NotificationCenter.default.post(name: .LoggieDidUpdateLogs, object: logs)
        }
    }

    private override init() {}

    @discardableResult
    @objc(showLogsFromViewController:filter:)
    public func showLogs(from viewController: UIViewController, filter: ((Log) -> Bool)? = nil) -> UINavigationController {
        let vc: LogListTableViewController = UIStoryboard(name: "LogListTableViewController", bundle: .loggie)
            .instantiateViewController(withIdentifier: "LogListTableViewController")
            as! LogListTableViewController
        vc.filter = filter
        vc.logsDataSourceDelegate = self

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()
            navigationController.navigationBar.standardAppearance = appearence
            navigationController.navigationBar.scrollEdgeAppearance = appearence
        }

        viewController.present(navigationController, animated: true, completion: nil)
        return navigationController
    }

    func add(_ log: Log) {
        // Avoid changing logs array from multiple threads (race condition)
        DispatchQueue.main.async { [weak self] in
            self?.logs.append(log)
        }
    }

    func clearLogs() {
        // Avoid changing logs array from multiple threads (race condition)
        DispatchQueue.main.async { [weak self] in
            self?.logs = []
        }
    }
}

