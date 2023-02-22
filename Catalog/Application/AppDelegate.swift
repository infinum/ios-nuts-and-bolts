//
//  AppDelegate.swift
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let securityProtectionManager = SecurityProtectionManager()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = createInitialWindow()
        securityProtectionManager.checkSystemStatus()
        securityProtectionManager.initiateFullSecurity(in: window)
        return true
    }

}

private extension AppDelegate {
    
    func createInitialWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = CatalogWireframe().viewController
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        return window
    }
    
}
