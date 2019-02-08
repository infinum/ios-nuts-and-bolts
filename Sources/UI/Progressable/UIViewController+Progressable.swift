//
//  UIViewController+Progressable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import MBProgressHUD

public extension Progressable where Self: UIViewController {
    
    private var _hudParentView: UIView {
        return view
    }
    
    // MARK: - Public methods -
    
    // MARK: - Show/hide
    
    public func showLoading() {
        showLoading(blocking: true)
    }
    
    public func hideLoading() {
        hideLoading(blocking: true)
    }
    
    // MARK: - Show/hide with blocking state
    
    public func showLoading(blocking: Bool) {
        // Remove previously added so we don't need to take care about
        // multiple async calls to show loading
        MBProgressHUD.hide(for: _hudParentView, animated: true)
        let hud = MBProgressHUD.showAdded(to: _hudParentView, animated: true)
        hud.isUserInteractionEnabled = blocking
    }
    
    public func hideLoading(blocking: Bool) {
        _stopRefreshingIfNeeded()
        MBProgressHUD.hide(for: _hudParentView, animated: true)
    }
    
    // MARK: - Failure handling
    
    public func showFailure(with error: Error) {
        showFailure(with: nil, message: error.localizedDescription)
    }
    
    public func showFailure(with title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertView, animated: true)
    }
    
    // MARK: - Private methods
    
    private func _stopRefreshingIfNeeded() {
        (self as? Refreshable)?.endRefreshing()
    }
    
}
