//
//  BaseInputFieldConfiguratorInterface.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineExt

public enum TextInputType {
    case text
    case phoneNumber
    /// Used for decimal number representation.
    /// Takes max number of non-decimal and decimal digits.
    case decimalNumber(integer: Int, decimal: Int)
}

@available(iOS 13.0, *)
public protocol BaseInputFieldConfiguratorInterface {

    // MARK: - Public properties -

    /// A text value to be set as the placeholder
    var placeholderText: String { get }

    /// Input type of the input field
    ///
    /// **Default value:** .text
    var textInputType: TextInputType { get }

    /// Set keyboard type
    ///
    /// **Default value:** .default
    var keyboardType: UIKeyboardType { get }

    /// Set return key type
    ///
    /// In form screens, next button is used to navigate to next text field. In last cell, done button should be used.\n
    /// **Default value:** .next
    var returnKeyType: UIReturnKeyType { get }

    /// Set text capitalization
    ///
    /// **Default value:** .none
    var capitalizationType: UITextAutocapitalizationType { get }

    /// Set correction type
    ///
    /// **Default value:** .default
    var correctionType: UITextAutocorrectionType { get }

    /// Used for defining text content type
    ///
    /// **Default value:** nil (unspecified)
    var textContentType: UITextContentType? { get }

    /// Set text field as a read only (user interaction disabled)
    ///
    /// **Default value:** false
    var readOnly: Bool { get }

    /// Sets the initial position of the placeholder to the top of the input field, as if an input already existed.
    /// Use this when initial inputs take a bit to load to prevent unwanted animations during input text binding.
    ///
    /// **Default value:** false
    var startsWithPlaceholderMinimized: Bool { get }

    /// Text change observation and for presetting value
    ///
    /// **Default value** nil
    var textChangedRelay: CurrentValueRelay<String?> { get }

    /// Set whether the text input needs to be secure or not
    ///
    /// **Default value:** false
    var isSecureTextEntry: Bool { get }

    /// First responder observation which can be triggered at any point.
    var shouldBecomeFirstResponderRelay: PassthroughRelay<Void>? { get }

    /// Sets a validator which is used to validate any potential validation issues during text input.
    ///
    /// **Default value:** nil
    var inputValidation: InputFieldValidation? { get }
}
