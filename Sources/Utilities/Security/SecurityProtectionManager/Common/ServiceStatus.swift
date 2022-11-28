//
//  ServiceStatus.swift
//  Catalog
//
//  Created by Leo Leljak on 28.11.2022..
//  Copyright © 2022 Infinum Ltd. All rights reserved.
//

import Foundation
import IOSSecuritySuite

enum SystemStatus {
    case online
    case offline
}

enum ServiceStatus {

    static var startSystem: SystemStatus {
        IOSSecuritySuite.amIDebugged() ? .online : .offline
    }

    static var firstLevel: SystemStatus {
        IOSSecuritySuite.amIJailbroken() ? .offline : .online
    }

    static var secondLevel: SystemStatus {
        (IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIProxied()) ? .online : .offline
    }
    
}
