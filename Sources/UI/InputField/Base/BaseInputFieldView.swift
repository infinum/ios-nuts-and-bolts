//
//  BaseInputFieldView.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineExt

@available(iOS 13.0, *)
public class BaseInputFieldView: UIView {

    // MARK: - IBOutlets -

    @IBOutlet private weak var mainContainerStackView: UIStackView!
    @IBOutlet private weak var inputFieldContainerView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!

    // MARK: - Public properties -

    public var textPublisher: AnyPublisher<String?, Never> {
        inputField.textPublisher
    }

    private(set) var textChangedRelay: CurrentValueRelay<String?>!

    @IBInspectable var isEnabled: Bool = true {
        didSet {
            inputField.alpha = isEnabled ? 1.0 : 0.3
        }
    }

    public var isHighlighted = false {
        didSet { setupEditingState(isEditing: isHighlighted) }
    }

    /// Error text shown under the text field
    ///
    /// When set, the label will be shown under the text field and text color will be changed to the `errorColor`
    public var errorText: String? {
        didSet { handle(error: errorText) }
    }

    public var errorColor: UIColor = .red {
        didSet { errorLabel.textColor = errorColor }
    }

    public var cancellables: Set<AnyCancellable> = []

    // MARK: - Private properties -

    private weak var inputField: BaseInputFieldInterface!

    private let animationSpeed: TimeInterval = 0.3
}

// MARK: - Extensions -

// MARK: - Configuration

@available(iOS 13.0, *)
public extension BaseInputFieldView {

    func configure(using configurator: BaseInputFieldConfiguratorInterface) {
        self.textChangedRelay = configurator.textChangedRelay

        handle(textChangeUsing: textPublisher, textChangedRelay: textChangedRelay)
        handle(validationUsing: textPublisher, textChangedRelay: textChangedRelay, inputValidation: configurator.inputValidation)
        handle(shouldBecomeFirstResponder: configurator.shouldBecomeFirstResponderRelay?.asDriver())
    }
}

// MARK: - UI setup

@available(iOS 13.0, *)
public extension BaseInputFieldView {

    func setup(using inputField: BaseInputFieldInterface) {
        self.inputField = inputField

        backgroundColor = .clear

        setupInputFieldContainerView()
        setupErrorLabel()
    }

    private func setupErrorLabel() {
        errorLabel.font = .systemFont(ofSize: 13)
        errorLabel.alpha = 0
        errorLabel.textColor = errorColor
        errorLabel.isHiddenInStackView = true
    }

    private func setupInputFieldContainerView() {
        inputFieldContainerView.backgroundColor = .gray
        inputFieldContainerView.roundCorners(corners: .allCorners, radius: 12)
    }
}

// MARK: - Editig state

@available(iOS 13.0, *)
public extension BaseInputFieldView {

    func setupEditingState(isEditing: Bool) {
        let color = errorText.isBlank ? .white : errorColor
        let isBorderVisible = isEditing || errorText.isNotBlank

        UIView.transition(
            with: self,
            duration: 0.2,
            options: [.transitionCrossDissolve, .allowUserInteraction, .curveEaseIn],
            animations: { [unowned self] in handle(isBorderVisible: isBorderVisible, color: color) }
        )
    }
}

// MARK: - Handlers

// MARK: Text changes

@available(iOS 13.0, *)
private extension BaseInputFieldView {

    func handle(textChangeUsing textPublisher: AnyPublisher<String?, Never>, textChangedRelay: CurrentValueRelay<String?>) {
        textPublisher
            .drop(while: \.isEmpty)
            .removeDuplicates()
            .bind(to: textChangedRelay)
            .store(in: &cancellables)

        let inputFieldHighlightHandler: (String?) -> Void = { [unowned self] text in
            guard inputField.readOnly, !isHighlighted, text.isNotBlank else { return }
            handle(isBorderVisible: false, color: .white)
        }

        textChangedRelay
            .removeDuplicates()
            .handleEvents(receiveOutput: inputFieldHighlightHandler)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak inputField] in inputField?.text = $0 })
            .store(in: &cancellables)
    }
}

// MARK: Validation

@available(iOS 13.0, *)
private extension BaseInputFieldView {

    func handle(
        validationUsing textPublisher: AnyPublisher<String?, Never>,
        textChangedRelay: CurrentValueRelay<String?>,
        inputValidation: InputFieldValidation?
    ) {
        guard let validation = inputValidation else { return }

        let typingValidationHandler: () -> Void = { [unowned self] in
            let textChange = Publishers.Merge(textPublisher.drop(while: \.isEmpty), textChangedRelay.dropFirst())

            // Added debounce for a better experience, when the users stops typing for 0.3 seconds to check if it's valid
            let validationResult = textChange
                .removeDuplicates()
                .debounce(for: .seconds(0.3))
                .map(validation.validate)
                .share()

            validationResult
                .sink(receiveValue: validation.update(with:))
                .store(in: &cancellables)

            validationResult
                .map(\.description)
                .assignWeakified(on: self, at: \.errorText)
                .store(in: &cancellables)
        }

        let triggeredValidationHandler: (CombineDriver<Void>) -> Void = { [unowned self] trigger in
            let textChange = Publishers.Merge(textPublisher.dropFirst(), textChangedRelay.dropFirst())

            textChange
                .removeDuplicates()
                .handleEvents(receiveOutput: { validation.update(with: validation.validate(value: $0 ?? "")) })
                .mapToValue(nil)
                .assignWeakified(on: self, at: \.errorText)
                .store(in: &cancellables)

            trigger
                .withLatestFrom(textChange)
                .map(validation.validate)
                .handleEvents(receiveOutput: { validation.update(with: $0) })
                .map(\.description)
                .assignWeakified(on: self, at: \.errorText)
                .store(in: &cancellables)
        }

        switch validation.handle {
        case .whileTyping:
            typingValidationHandler()
        case .triggered(let action):
            triggeredValidationHandler(action)
        }
    }
}

// MARK: Error handling

@available(iOS 13.0, *)
private extension BaseInputFieldView {

    func handle(error: String?) {
        let shouldShowError = !error.isBlank
        let color = error.isBlank ? .white : errorColor

        if shouldShowError {
            errorLabel.text = error
            errorLabel.setNeedsLayout()
            errorLabel.layoutIfNeeded()
            handle(isBorderVisible: true, color: color)
        }

        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: animationSpeed) {
            self.errorLabel.alpha = shouldShowError ? 1 : 0
            self.errorLabel.isHiddenInStackView = !shouldShowError
            self.mainContainerStackView.layoutIfNeeded()
        } completion: { [weak errorLabel] completed in
            guard completed, !shouldShowError else { return }
            errorLabel?.text = nil
        }
        inputFieldContainerView.animateBorderColor(toColor: color, duration: animationSpeed)
    }
}

// MARK: Utility

@available(iOS 13.0, *)
private extension BaseInputFieldView {

    func handle(isBorderVisible: Bool, color: UIColor) {
        inputFieldContainerView.layer.borderWidth = isBorderVisible ? 1 : 0
        inputFieldContainerView.layer.borderColor = color.cgColor
    }

    func handle(shouldBecomeFirstResponder: CombineDriver<Void>?) {
        shouldBecomeFirstResponder?
            .sink(receiveValue: { [weak inputField] in inputField?.becomeFirstResponder() })
            .store(in: &cancellables)
    }
}
