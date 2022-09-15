//
//  NotificationCenterPublisher+Unwrapping.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public extension NotificationCenter.Publisher {

    /// Unwraps the notifications for the specified type at the speficied key
    ///
    /// - Parameters:
    ///  - key: Key at which the object will be unwrapped
    ///  - type: Type of the object to which it will try to unwrap
    ///
    /// - Returns: AnyPublisher with the unwrapped value if there is one
    func unwrapNotificationObject<T>(for key: String, ofType type: T.Type) -> AnyPublisher<T, Never> {
        compactMap { $0.object as? NSDictionary }
            .compactMap { $0[key] as? T }
            .eraseToAnyPublisher()
    }
}
