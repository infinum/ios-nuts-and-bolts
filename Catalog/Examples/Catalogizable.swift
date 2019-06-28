//
//  Catalogizable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

protocol Catalogizable {
    
    /// Catalog item title - shown in catalog table view
    static var title: String { get }
    
    /// Example view controller to display - it will be pushed
    static var viewController: UIViewController { get }
    
}
