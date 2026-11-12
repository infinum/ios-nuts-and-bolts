//
//  InputFieldViewTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import XCTest
import Combine
import CombineExt
@testable import Catalog

@available(iOS 14.0, *)
class InputFieldViewTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        cancellables = []
    }

    func testTapGestureInvalidInputFieldDisabled() {
        let tapActionRelay = PassthroughRelay<Void>()
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", readOnly: true, tapActionRelay: tapActionRelay)
        let inputFieldView = configurator.view as! InputFieldView
        inputFieldView.isEnabled = false
        let tapGesture = inputFieldView.gestureRecognizers?.first as! UITapGestureRecognizer
        var calledCount = 0

        let expectation = expectation(description: "Tap Action Not Received")
        tapActionRelay
            .sink(receiveValue: { calledCount += 1 })
            .store(in: &cancellables)

        tapGesture.state = .ended

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 0)
    }

    func testTapGestureInvalidNotReadOnly() {
        let tapActionRelay = PassthroughRelay<Void>()
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", readOnly: false, tapActionRelay: tapActionRelay)
        let inputFieldView = configurator.view as! InputFieldView
        inputFieldView.isEnabled = true
        let tapGesture = inputFieldView.gestureRecognizers?.first as! UITapGestureRecognizer
        var calledCount = 0

        let expectation = expectation(description: "Tap Action Not Received")
        tapActionRelay
            .sink(receiveValue: { calledCount += 1 })
            .store(in: &cancellables)

        tapGesture.state = .began
        tapGesture.state = .ended

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 0)
    }

    func testTapGestureInvalidNotReadOnlyAndNotEnabled() {
        let tapActionRelay = PassthroughRelay<Void>()
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", readOnly: false, tapActionRelay: tapActionRelay)
        let inputFieldView = configurator.view as! InputFieldView
        inputFieldView.isEnabled = false
        let tapGesture = inputFieldView.gestureRecognizers?.first as! UITapGestureRecognizer
        var calledCount = 0

        let expectation = expectation(description: "Tap Action Not Received")
        tapActionRelay
            .sink(receiveValue: { calledCount += 1 })
            .store(in: &cancellables)

        tapGesture.state = .began
        tapGesture.state = .ended

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 0)
    }

    func testTapGestureValid() {
        let tapActionRelay = PassthroughRelay<Void>()
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", readOnly: true, tapActionRelay: tapActionRelay)
        let inputFieldView = configurator.view as! InputFieldView
        let tapGesture = inputFieldView.gestureRecognizers?.first as! UITapGestureRecognizer

        let expectation = expectation(description: "Tap Action Received")
        tapActionRelay
            .sink(receiveValue: { expectation.fulfill() })
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tapGesture.state = .ended
        }

        wait(for: [expectation], timeout: 3)
    }

    func testPlaceholder() {
        let placeholder = "placeholder"
        let configurator = InputFieldConfigurator(placeholderText: placeholder)
        let inputFieldView = configurator.view as! InputFieldView
        let stackView = inputFieldView.subviews.first?.subviews.first as! UIStackView
        let inputField = stackView.arrangedSubviews.first?.subviews.first as! InputField

        XCTAssertEqual(inputField.placeholder, placeholder)
    }

    func testInitialInputValidation() {
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping
        )

        let expectation = expectation(description: "Validation fails, no input")
        inputValidation
            .isValid
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testOptionalInitailInputValidationValid() {
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping,
            isInitialValidationRequired: false
        )

        let expectation = expectation(description: "Validation successful, no initial validation")
        inputValidation
            .isValid
            .sink(receiveValue: {
                XCTAssertTrue($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testInputFieldValidationValid() {
        let valueToValidate = "value"
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping,
            isInitialValidationRequired: false
        )

        let expectation = expectation(description: "Validation successful, valid value")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputValidation.update(with: inputValidation.validate(value: valueToValidate))
        }
        inputValidation
            .isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertTrue($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testInputFieldValidationInvalid() {
        let invalidValueToValidate = ""
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping,
            isInitialValidationRequired: false
        )

        let expectation = expectation(description: "Validation fails, invalid value")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputValidation.update(with: inputValidation.validate(value: invalidValueToValidate))
        }
        inputValidation
            .isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testInputFieldViewValidationWhileTypingInvalid() {
        let invalidValueToValidate = ""
        let textChangedRelay = CurrentValueRelay<String?>(nil)
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping,
            isInitialValidationRequired: false
        )

        let configurator = InputFieldConfigurator(placeholderText: "placeholder", textChangedRelay: textChangedRelay, inputValidation: inputValidation)
        let inputFieldView = configurator.view as! InputFieldView

        let expectation = expectation(description: "Validation fails, invalid value while typing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputFieldView.textChangedRelay.accept(invalidValueToValidate)
        }
        inputValidation
            .isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testInputFieldViewValidationWhileTypingValid() {
        let valueToValidate = "value"
        let textChangedRelay = CurrentValueRelay<String?>(nil)
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .whileTyping,
            isInitialValidationRequired: false
        )

        let configurator = InputFieldConfigurator(placeholderText: "placeholder", textChangedRelay: textChangedRelay, inputValidation: inputValidation)
        let inputFieldView = configurator.view as! InputFieldView

        let expectation = expectation(description: "Validation successful, valid value while typing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputFieldView.textChangedRelay.accept(valueToValidate)
        }
        inputValidation
            .isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertTrue($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    func testInputFieldViewValidationTriggerNotTriggered() {
        let validationTriggerActionRelay = PassthroughRelay<Void>()
        let textChangedRelay = CurrentValueRelay<String?>(nil)
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .triggered(action: validationTriggerActionRelay.asSignal())
        )
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", textChangedRelay: textChangedRelay, inputValidation: inputValidation)
        let inputFieldView = configurator.view as! InputFieldView
        inputFieldView.textChangedRelay.accept(nil)

        var calledCount = 0
        var lastValue: Bool?

        let expectation = expectation(description: "Validation fails, not triggered")
        inputValidation
            .isValid
            .sink(receiveValue: {
                calledCount += 1
                lastValue = $0
            })
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 1)
        XCTAssertFalse(lastValue ?? true)
    }

    func testInputFieldViewValidationTriggerInvalid() {
        let validationTriggerActionRelay = PassthroughRelay<Void>()
        let invalidValueToValidate = ""
        let textChangedRelay = CurrentValueRelay<String?>(nil)
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .triggered(action: validationTriggerActionRelay.asSignal()),
            isInitialValidationRequired: false
        )
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", textChangedRelay: textChangedRelay, inputValidation: inputValidation)
        let inputFieldView = configurator.view as! InputFieldView

        var calledCount = 0
        var lastValue: Bool?

        let expectation = expectation(description: "Validation fails, invalid value with trigger")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputFieldView.textChangedRelay.accept(invalidValueToValidate)
            validationTriggerActionRelay.accept(())
        }
        inputValidation
            .isValid
            .sink(receiveValue: {
                calledCount += 1
                lastValue = $0
            })
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 3)
        XCTAssertFalse(lastValue ?? true)
        XCTAssertEqual(inputFieldView.errorText, RequiredValueValidator().invalidInputDescription)
    }

    func testInputFieldViewValidationTriggerValid() {
        let validationTriggerActionRelay = PassthroughRelay<Void>()
        let valueToValidate = "value"
        let textChangedRelay = CurrentValueRelay<String?>(valueToValidate)
        let inputValidation = InputFieldValidation(
            validators: RequiredValueValidator(),
            handle: .triggered(action: validationTriggerActionRelay.asSignal())
        )
        let configurator = InputFieldConfigurator(placeholderText: "placeholder", textChangedRelay: textChangedRelay, inputValidation: inputValidation)
        let inputFieldView = configurator.view as! InputFieldView

        var calledCount = 0
        var lastValue: Bool?

        let expectation = expectation(description: "Validation successful, valid input with trigger")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            inputFieldView.textChangedRelay.accept(valueToValidate)
            validationTriggerActionRelay.accept(())
        }
        inputValidation
            .isValid
            .sink(receiveValue: {
                calledCount += 1
                lastValue = $0
            })
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(calledCount, 3)
        XCTAssertTrue(lastValue ?? true)
        XCTAssertNil(inputFieldView.errorText)
    }
}
