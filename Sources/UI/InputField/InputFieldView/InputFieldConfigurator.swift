//
//  InputFieldConfigurator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import CombineExt

@available(iOS 13.0, *)
public struct InputFieldConfigurator: BaseInputFieldConfiguratorInterface {

    /// A text value to be set as the placeholder
    public var placeholderText: String

    /// Input type of the input field
    ///
    /// **Default value:** .text
    public var textInputType: TextInputType = .text

    /// Set keyboard type
    ///
    /// **Default value:** .default
    public var keyboardType: UIKeyboardType = .default

    /// Set return key type
    ///
    /// In form screens, next button is used to navigate to next text field. In last cell, done button should be used.\n
    /// **Default value:** .next
    public var returnKeyType: UIReturnKeyType = .next

    /// Set text capitalization
    ///
    /// **Default value:** .none
    public var capitalizationType: UITextAutocapitalizationType = .none

    /// Set correction type
    ///
    /// **Default value:** .default
    public var correctionType: UITextAutocorrectionType = .default

    /// Used for defining text content type
    ///
    /// **Default value:** nil (unspecified)
    public var textContentType: UITextContentType?

    /// Set text field as a read only (user interaction disabled)
    ///
    /// **Default value:** false
    public var readOnly = false

    /// Sets the initial position of the placeholder to the top of the input field, as if an input already existed.
    /// Use this when initial inputs take a bit to load to prevent unwanted animations during input text binding.
    ///
    /// **Default value:** false
    public var startsWithPlaceholderMinimized = false

    /// Text change observation and for presetting value
    ///
    /// **Default value** nil
    public var textChangedRelay: CurrentValueRelay<String?> = .init(nil)

    /// Tap action observation, used to send events when the field is in `readOnly` mode.
    ///
    /// **Default value** nil
    public var tapActionRelay: PassthroughRelay<Void>?

    /// Set whether the text input needs to be secure or not
    ///
    /// **Default value:** false
    public var isSecureTextEntry = false

    /// First responder observation which can be triggered at any point.
    public var shouldBecomeFirstResponderRelay: PassthroughRelay<Void>?

    /// Sets a validator which is used to validate any potential validation issues during text input.
    ///
    /// **Default value:** nil
    public var inputValidation: InputFieldValidation?
}

// MARK: - Component configurable conformance

@available(iOS 14.0, *)
extension InputFieldConfigurator: ComponentConfigurable {

    public var view: UIView {
        let view = InputFieldView()
        view.configure(with: self)
        return view
    }
}
