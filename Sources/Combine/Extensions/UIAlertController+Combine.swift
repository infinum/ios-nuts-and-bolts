//
//  UIAlertController+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 24.11.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import Combine

/// Combine alert action wrapper
@available(iOS 13, *)
public struct CombineAlertAction<T> {

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

    func asUIAlertAction(with completed: @escaping (Result<T?, Never>) -> Void) -> UIAlertAction {
        return UIAlertAction(title: title, style: style) { _ in
            guard let value = self.value else {
                completed(.success(nil))
                return
            }
            completed(.success(value))
        }
    }

}

@available(iOS 13, *)
public extension UIAlertController {

    /// Creates and presents alert controller while returning selected action value.
    ///
    /// - Parameters:
    ///   - viewController: Parent view controller
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actions: Actions
    ///   - style: Alert style - sheet or alert
    /// - Returns: `Optional.Publisher` type containing selected value
    static func present<T>(
        on viewController: UIViewController,
        title: String? = nil,
        message: String? = nil,
        actions: [CombineAlertAction<T>] = [],
        style: UIAlertController.Style
    ) -> Publishers.CompactMap<Future<T?, Never>, T> {
        return Future { promise in
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)

            actions
                .map { $0.asUIAlertAction(with: promise) }
                .forEach { alert.addAction($0) }

            viewController.present(alert, animated: true, completion: nil)

        }
        .compactMap { $0 }
    }
}
