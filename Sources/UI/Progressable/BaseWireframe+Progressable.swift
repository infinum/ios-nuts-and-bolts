//
//  BaseWireframe+Progressable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import MBProgressHUD

public extension Progressable where Self: BaseWireframe {
    
    private var hudParentView: UIView {
        return viewController.view
    }
    
    // MARK: - Public methods -
    
    // MARK: - Show/hide
    
    func showLoading() {
        showLoading(blocking: true)
    }

    func hideLoading() {
        hideLoading(blocking: true)
    }
    
    // MARK: - Show/hide with blocking state
    
    func showLoading(blocking: Bool) {
        // Remove previously added so we don't need to take care about
        // multiple async calls to show loading
        MBProgressHUD.hide(for: hudParentView, animated: true)
        let hud = MBProgressHUD.showAdded(to: hudParentView, animated: true)
        hud.isUserInteractionEnabled = blocking
    }
    
    func hideLoading(blocking: Bool) {
        stopRefreshingIfNeeded()
        MBProgressHUD.hide(for: hudParentView, animated: true)
    }

    // MARK: - Failure handling
    
    func showFailure(with error: Error) {
        showFailure(with: nil, message: error.localizedDescription)
    }
    
    func showFailure(with title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel))
        viewController.present(alertView, animated: true)
    }
    
    // MARK: - Private methods
    
    private func stopRefreshingIfNeeded() {
        (viewController as? Refreshable)?.endRefreshing()
    }
    
}
