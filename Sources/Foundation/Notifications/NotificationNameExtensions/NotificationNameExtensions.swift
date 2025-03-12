//
//  NotificationNameExtensions.swift
//  Catalog
//
//  Created by Zvonimir Medak on 12.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import Foundation

extension Notification.Name {

    static var accessTokenRefreshed: Notification.Name {
        .init("AccessTokenRefreshed")
    }

    static var clientTokenRefreshed: Notification.Name {
        .init("ClientTokenRefreshed")
    }

    static var sessionExpired: Notification.Name {
        .init("SessionExpired")
    }

}
