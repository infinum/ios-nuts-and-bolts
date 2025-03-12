//
//  InputFieldValidation.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Combine
import CombineExt

@available(iOS 13.0, *)
public struct InputFieldValidation {

    // MARK: - Public properties -

    public let validators: [StringValidator]
    public var handle: ValidationHandle
    public var isValid: CombineDriver<Bool> { validationRelay.asDriver() }

    // MARK: - Private properties -

    private let validationRelay: CurrentValueRelay<Bool>

    // MARK: - Init -

    /// Init(validators:handle:isInitialValidationRequired:).
    ///
    /// - Parameters:
    ///   - validators: a variadic parameter which takes in any number of StringValidators
    ///   - handle: type of validation handling, defaults to `.whileTyping`
    ///   - isInitialValidationRequired: tells the validation if the initial validation is required. It's not required on optional input fields, defaults to `true`
    public init(
        validators: StringValidator...,
        handle: InputFieldValidation.ValidationHandle = .whileTyping,
        isInitialValidationRequired: Bool = true
    ) {
        self.validators = validators
        self.handle = handle
        self.validationRelay = .init(!isInitialValidationRequired)
    }

    // MARK: - Public functions -

    public func update(with validationResult: ValidationResult) {
        validationRelay.accept(validationResult.isValid)
    }

    public func validate(value: String?) -> ValidationResult {
        guard let value = value, let invalidValidator = validators.first(where: { !$0.validate(value) }) else { return .valid }
        return .invalid(description: invalidValidator.invalidInputDescription)
    }
}

// MARK: - Extensions -

// MARK: - Validation handle definition

@available(iOS 13.0, *)
public extension InputFieldValidation {

    enum ValidationHandle {
        case whileTyping
        case triggered(action: CombineSignal<Void>)
    }

    enum ValidationResult {
        case valid
        case invalid(description: String)

        var isValid: Bool {
            switch self {
            case .valid: return true
            case .invalid: return false
            }
        }

        var isInvalid: Bool { !isValid }

        var description: String? {
            switch self {
            case .valid: return nil
            case .invalid(let description): return description
            }
        }
    }
}
