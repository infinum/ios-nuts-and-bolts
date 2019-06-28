//
//  Refreshable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public protocol Refreshable {
    var refreshControl: UIRefreshControl { get }
}

public extension Refreshable {
    
    func endRefreshing() {
        // Check if refresh control is refreshing before calling endRefreshing,
        // otherwise it will result in wierd glitch while scrolling and reloading
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
}
