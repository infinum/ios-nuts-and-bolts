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

    /// Timer used for periodic checks of the system status.
    private var systemCheckTimer: SecurityTimer?
    
    /// Interval in which the periodic timer will trigger system checks.
    private let systemCheckInterval: TimeInterval = 3.0
    
    /// First level status of system which tells if device is Jailbroken.
    private var firstLevel: SecurityService.SystemStatus?
    
    private let disposeBag = DisposeBag()
    
}

// MARK: - Public methods

extension SecurityProtectionManager {

    /// Checks current system status.
    ///
    /// In the case where device is jailbroken and there are reverse engineering
    /// actions performed, debugger is denied and app is forced to crash.
    func checkSystemStatus() {
        guard !isSimulator else { return }
        if firstLevel == nil {
            firstLevel = SecurityService.ServiceStatus.firstLevel
        }
        let startupSystem = SecurityService.ServiceStatus.startSystem == .online
        let secondLevel = SecurityService.ServiceStatus.secondLevel == .online
        if firstLevel == .offline && (startupSystem || secondLevel) {
            IOSSecuritySuite.denyDebugger()
            exit(0)
        }
    }

    
    /// Initiates full application security which consist of multiple layers of security.
    ///
    /// - Parameter window: UIWindow on which blur will be applied
    func initiateFullSecurity(in window: UIWindow?) {
        guard !isSimulator else { return }
        protectAppInBackground(window: window)
        biometricChangesCheck()
        firstLevelSystemCheck()
        initiatePeriodicSystemCheck()
    }
    
}

// MARK: - Protections

private extension SecurityProtectionManager {

    /// Checks if device is Jailbroken when app finishes launching.
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
    func initiatePeriodicSystemCheck() {
        UIApplication.rx.didBecomeActive
            .startWith(())
            .filter { [unowned self] in firstLevel == .offline }
            .subscribe(onNext: { [unowned self] in
                startPeriodicSystemCheck()
            })
            .disposed(by: disposeBag)
    }

    /// Handles background app state. Adds or removes the blur based on app state and security system states.
    ///
    /// - Parameter window: window on which blur will be applied
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

        handleAddBlur(animated: Observable.merge(inModified, inNonModified), in: window)
        handleRemoveBlur(in: window)
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
    
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static func shouldAddBlur(for level: SecurityService.SystemStatus) -> Bool {
        // Add additional custom logic to check if blur should be added
        return SecurityService.ServiceStatus.firstLevel == level
    }
    
    func startPeriodicSystemCheck() {
        systemCheckTimer = SecurityTimer(timeInterval: systemCheckInterval)
        systemCheckTimer?.eventHandler = { [weak self] in
            self?.checkSystemStatus()
        }
        systemCheckTimer?.resume()
    }

    func checkSystemChange() {
        guard SecurityService.ServiceStatus.firstLevel == .offline else { return }
        // Device is Jailbroken
        // Add custom logic for showing alert or restricting access to the application.
    }
    
    func handleAddBlur(animated: Observable<Bool>, in window: UIWindow?) {
        animated
            .asDriverOnErrorComplete()
            .drive(onNext: { animated in
                window?.blur(style: .regular, at: .foreground, animated: animated)
            })
            .disposed(by: disposeBag)
    }
    
    func handleRemoveBlur(in window: UIWindow?) {
        UIApplication.rx.didBecomeActive
            .asDriver()
            .drive(onNext: {
                UIView.animate(withDuration: 0.2, animations: {
                    window?.removeBlur(at: .foreground, animated: true)
                })
            })
            .disposed(by: disposeBag)
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
