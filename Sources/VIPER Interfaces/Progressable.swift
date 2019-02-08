//
//  Progressable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public protocol Progressable: class {
    func showLoading()
    func hideLoading()
    
    func showLoading(blocking: Bool)
    func hideLoading(blocking: Bool)
    
    func showFailure(with error: Error)
    func showFailure(with title: String?, message: String?)
}

public extension Progressable {
    func showLoading(blocking: Bool) { }
    func hideLoading(blocking: Bool) { }

    func showFailure(with error: Error) { }
    func showFailure(with title: String?, message: String?) { }
}
