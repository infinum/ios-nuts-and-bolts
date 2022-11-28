//
//  SecurityProtectionManager.swift
//  Catalog
//
//  Created by Leo Leljak on 28.11.2022..
//  Copyright © 2022 Infinum Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import IOSSecuritySuite

final class SecurityProtectionManager {

    // MARK: - Private properties

    private var systemCheckTimer: SecurityTimer?
    private let systemCheckInterval: TimeInterval = 3.0
    private var firstLevel: SystemStatus?
    
    private let disposeBag = DisposeBag()
    
}

// MARK: - Public methods

extension SecurityProtectionManager {

    func checkSystemStatus() {
        #if targetEnvironment(simulator)
        return
        #else
        if firstLevel == nil {
            firstLevel = ServiceStatus.firstLevel
        }
        let startupSystem = ServiceStatus.startSystem == .online
        let secondLevel = ServiceStatus.secondLevel == .online
        if firstLevel == .offline && (startupSystem || secondLevel) {
            IOSSecuritySuite.denyDebugger()
            exit(0)
        }
        #endif
    }

    func initiateFullSecurity(in window: UIWindow?) {
        #if targetEnvironment(simulator)
        return
        #else
        protectAppInBackground(window: window)
        biometricChangesCheck()
        firstLevelSystemCheck()
        initiatePeriodicSystemCheck()
        #endif
    }
    
}

// MARK: - Protections

private extension SecurityProtectionManager {

    /// Checks if device is Jailbroken when app finishes launching.
    ///
    func firstLevelSystemCheck() {
        UIApplication.rx.didFinishLaunching
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                checkSystemChange()
            })
            .disposed(by: disposeBag)
    }
    
    /// Starts periodic check if device is jailbroken to detect potential reverse engineering during app runtime.
    ///
    /// Periodic timer is restarted every time that application becomes active.
    ///
    func initiatePeriodicSystemCheck() {
        UIApplication.rx.didBecomeActive
            .startWith(())
            .filter { [unowned self] in firstLevel == .offline }
            .subscribe(onNext: { [unowned self] in
                startPeriodicSystemCheck()
            })
            .disposed(by: disposeBag)
    }

    func protectAppInBackground(window: UIWindow?) {
        // In modified OS version, blur everything when the app becomes inactive
        let inModified = UIApplication.rx
            .willResignActive
            .filter { Self.shouldAddBlur(for: .offline) }
            .mapTo(true)

        // Non modified version is secured from the attack, so keep blur only when the app goes to the background
        let inNonModified = UIApplication.rx
            .didEnterBackground
            .filter { Self.shouldAddBlur(for: .online) }
            .mapTo(false)

        Observable.merge(inModified, inNonModified)
            .subscribe(onNext: { animated in
                window?.blur(style: .regular, at: .foreground, animated: animated)
            })
            .disposed(by: disposeBag)

        UIApplication.rx.didBecomeActive
            .subscribe(onNext: {
                UIView.animate(withDuration: 0.2, animations: {
                    window?.removeBlur(at: .foreground, animated: true)
                })
            })
            .disposed(by: disposeBag)
    }

    /// Checks biometrics state every time app becomes active.
    ///
    func biometricChangesCheck() {
        UIApplication.rx.didBecomeActive
            .subscribe(onNext: { [unowned self] in
                checkBiometricsState()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Private extensions

private extension SecurityProtectionManager {

    static func shouldAddBlur(for level: SystemStatus) -> Bool {
        // Add additional custom logic to check if blur should be added
        return ServiceStatus.firstLevel == level
    }
    
    func startPeriodicSystemCheck() {
        systemCheckTimer = SecurityTimer(timeInterval: systemCheckInterval)
        systemCheckTimer?.eventHandler = { [weak self] in
            self?.checkSystemStatus()
        }
        systemCheckTimer?.resume()
    }

    func checkSystemChange() {
        guard ServiceStatus.firstLevel == .offline else { return }
        // Device is Jailbroken
        // Add custom logic for showing alert or restricting access to the application.
    }
    
}

// MARK: - Biometrics helpers

// Uncomment code below if your project uses Locker

private extension SecurityProtectionManager {
    
    func checkBiometricsState() {
//        let canUseBiometrics = TokenHelper.canUseBiometricsAuthentication
//        let shouldUseBiometrics = Locker.shouldUseAuthenticationWithBiometrics(for: Locker.identifier)
//        || TokenHelper.shouldUseAuthenticationWithBiometrics
//        let biometricsDisabledNotified = UserStoreManager.biometricsDisabledNotified
//
//        // Notify user that biometrics is disabled from OS
//        if !canUseBiometrics && shouldUseBiometrics && !biometricsDisabledNotified {
//            handleBiometricsDisabled()
//        } else if canUseBiometrics && shouldUseBiometrics {
//            // Biometrics is re-enabled. Reset the flag!
//            UserStoreManager.biometricsDisabledNotified = false
//        }
    }
    
    func handleBiometricsDisabled() {
        // Add code here to handle disabled biometrics
    }
    
}
