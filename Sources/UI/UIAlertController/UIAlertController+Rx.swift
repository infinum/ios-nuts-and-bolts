//
//  UIAlertController+Rx.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift

/// Reactive alert action wrapper
public struct AlertAction<T> {
    
    /// Action title
    public let title: String
    /// Action style
    public let style: UIAlertAction.Style
    /// Value which will be returned upon confirming action
    public let value: T?
    
    public init(title: String, style: UIAlertAction.Style = .default, value: T? = nil) {
        self.title = title
        self.style = style
        self.value = value
    }
    
    func asUIAlertAction(with maybe: @escaping (MaybeEvent<T>) -> ()) -> UIAlertAction {
        return UIAlertAction(title: title, style: style) { _ in
            guard let value = self.value else {
                maybe(.completed)
                return
            }
            maybe(.success(value))
        }
    }
    
}

public extension UIAlertController {
    
    /// Creates and presents alert controller while returning selected action value.
    ///
    /// - Parameters:
    ///   - viewController: Parent view controller
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actions: Actions
    ///   - style: Alert style - sheet or alert
    /// - Returns: `Maybe` type containing selected value
    public static func present<T>(
        on viewController: UIViewController,
        title: String? = nil,
        message: String? = nil,
        actions: [AlertAction<T>] = [],
        style: UIAlertController.Style
    ) -> Maybe<T> {
        return Maybe.create(subscribe: { [weak viewController] (maybe) -> Disposable in
            guard let viewController = viewController else { return Disposables.create() }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            actions
                .map { $0.asUIAlertAction(with: maybe) }
                .forEach { alert.addAction($0) }
            
            viewController.present(alert, animated: true, completion: nil)
            
            return Disposables.create { [weak alert] in
                DispatchQueue.main.async {
                    alert?.dismiss(animated: true)
                }
            }
        })
        .subscribeOn(MainScheduler.instance)
    }
    
}
