//
//  ServiceStatus.swift
//  Catalog
//
//  Created by Leo Leljak on 28.11.2022..
//  Copyright © 2022 Infinum Ltd. All rights reserved.
//

import Foundation
import IOSSecuritySuite

enum SecurityService {
    
    enum SystemStatus {
        case online
        case offline
    }
    
    enum ServiceStatus {
        
        /// Status which checks if device is being debugged.
        ///
        /// Start system is online if device is being debugged.
        static var startSystem: SystemStatus {
            IOSSecuritySuite.amIDebugged() ? .online : .offline
        }
        
        /// Status which checks if device is jailbroken.
        ///
        /// First level is offline if device is jailbroken.
        static var firstLevel: SystemStatus {
            IOSSecuritySuite.amIJailbroken() ? .offline : .online
        }

        /// Status which checks if device is being reverse engineered or proxied.
        ///
        /// Second level is online if device is being reverse engineered or proxied.
        static var secondLevel: SystemStatus {
            (IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIProxied()) ? .online : .offline
        }
        
    }
    
}
