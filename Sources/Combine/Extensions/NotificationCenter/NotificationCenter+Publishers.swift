//
//  NotificationCenter+Publishers.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Combine
import UIKit

@available(iOS 13.0, *)
public extension NotificationCenter {

    // Example of makeNotificationCenterPublisher usage
    var applicationDidBecomeActivePublisher: AnyPublisher<Void, Never> {
        makeNotificationCenterPublisher(for: UIApplication.didBecomeActiveNotification)
    }

    /// Creates AnyPublisher publisher for a specified NSNotification.Name
    ///
    /// - Parameters:
    ///  - notification: Notification name of the notification which will be observed
    ///
    /// - Returns: AnyPublisher
    @available(iOS 13.0, *)
    private func makeNotificationCenterPublisher(for notification: NSNotification.Name) -> AnyPublisher<Void, Never> {
        self
            .publisher(for: notification)
            .mapToVoid()
            .eraseToAnyPublisher()
    }
}
