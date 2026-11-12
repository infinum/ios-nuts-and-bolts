//
//  InputFieldView.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa
import CombineExt

@available(iOS 14.0, *)
public final class InputFieldView: BaseInputFieldView, NibOwnerLoadable {

    // MARK: - IBOutlets -

    @IBOutlet private weak var inputField: InputField!

    // MARK: - Public properties -

    public var tapPublisher: CombineSignal<InputFieldView> {
        tapGestureRecognizer.tapPublisher
            .mapToVoid()
            .filter { [unowned self] in inputField.readOnly && isEnabled }
            .map { [unowned self] in self }
            .asSignal()
    }

    public var contentView: UIView?

    // MARK: - Private properties -

    private var textInputType: TextInputType = .text

    private var textField: TextField {
        inputField.textField
    }

    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var tapActionRelay: PassthroughRelay<Void>?

    // MARK: - Lifecycle -

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Extensions -

// MARK: - Configuration

@available(iOS 14.0, *)
public extension InputFieldView {

    func configure(with configurator: InputFieldConfigurator) {
        configureInputField(with: configurator)
        configureTextField(with: configurator)

        handle(tapGestureAction: tapGestureRecognizer.tapPublisher, tapGestureRelay: configurator.tapActionRelay)

        super.configure(using: configurator)
    }

    private func configureInputField(with configurator: InputFieldConfigurator) {
        textInputType = configurator.textInputType
        tapActionRelay = configurator.tapActionRelay

        inputField.placeholder = configurator.placeholderText
        inputField.readOnly = configurator.readOnly
        inputField.startsWithPlaceholderMinimized = configurator.startsWithPlaceholderMinimized
    }

    private func configureTextField(with configurator: InputFieldConfigurator) {
        textField.keyboardType = configurator.keyboardType
        textField.autocapitalizationType = configurator.capitalizationType
        textField.returnKeyType = configurator.returnKeyType
        textField.autocorrectionType = configurator.correctionType
        textField.textContentType = configurator.textContentType
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = configurator.isSecureTextEntry
        textField.backgroundColor = .clear
        textField.setupRightView(isSecureTextEntry: configurator.isSecureTextEntry, frame: inputField.frame)
    }
}

// MARK: - UI setup

@available(iOS 14.0, *)
private extension InputFieldView {

    func setupUI() {
        loadNibContent()

        setupTextField()
        setupTapGesture()

        super.setup(using: inputField)
    }

    func setupTextField(hasText: Bool = false) {
        textField.delegate = self
        let configuration = InputFieldConfiguration(
            textColor: .white,
            cursorColor: .white,
            placeholderColor: .lightGray
        )
        inputField.configure(with: configuration)
    }

    func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = tapGestureRecognizer
    }
}

// MARK: - TextField delegate

@available(iOS 14.0, *)
extension InputFieldView: UITextFieldDelegate {

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorText = nil
        textField.update(text: nil)
        return true
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setupEditingState(isEditing: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        setupEditingState(isEditing: false)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - Handlers

@available(iOS 14.0, *)
private extension InputFieldView {

    func handle(tapGestureAction: AnyPublisher<UITapGestureRecognizer, Never>, tapGestureRelay: PassthroughRelay<Void>?) {
        tapGestureAction
            .mapToVoid()
            .filter { [unowned self] in inputField.readOnly && isEnabled }
            .sink(receiveValue: { tapGestureRelay?.accept(()) })
            .store(in: &cancellables)
    }
}
