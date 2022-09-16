//
//  BaseInputFieldInterface.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine

/// A protocol that each input field that can be embedded in the `BaseInputFieldView` needs to inherit.
///
/// Conforming to the interface enables base input actions such as text input handling, validations and error handling.
@available(iOS 13.0, *)
public protocol BaseInputFieldInterface: AnyObject {
    var text: String? { get set }
    var textPublisher: AnyPublisher<String?, Never> { get }
    var alpha: CGFloat { get set }
    var readOnly: Bool { get }

    func becomeFirstResponder()
}
