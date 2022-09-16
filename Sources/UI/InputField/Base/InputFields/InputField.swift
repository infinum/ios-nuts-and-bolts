//
//  InputField.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine

public struct InputFieldConfiguration {
    let textColor: UIColor
    let cursorColor: UIColor
    let placeholderColor: UIColor
}

@available(iOS 14.0, *)
public final class InputField: UIView {

    // MARK: - Public properties -

    /// Placeholder text for the floating placeholder label
    var placeholder: String? {
        get { placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    /// Main text field
    let textField = TextField()

    /// Set input field in read-only state
    ///
    /// When set, the input field will hide the bottom line and disable user interaction.
    public var readOnly = false {
        didSet {
            isUserInteractionEnabled = !readOnly
        }
    }

    /// Sets the initial position of the placeholder to the top of the input field, as if an input already existed.
    /// Use this when initial inputs take a bit to load to prevent unwanted animations during input text binding.
    var startsWithPlaceholderMinimized = false

    // MARK: - Private properties -

    // Colors
    private var textColor: UIColor?
    private var cursorColor: UIColor?
    private var placeholderColor: UIColor?

    // Internal UI components
    private let placeholderLabel = UILabel()

    // Constraints
    private var inputFieldHeightConstraint: NSLayoutConstraint!
    private var errorLabelBottomConstraint: NSLayoutConstraint!

    // Internal configurations
    private let animationSpeed: TimeInterval = 0.2
    private let paddingInactive: CGFloat = 20
    private let paddingActive: CGFloat = 10
    private var mainHeight: CGFloat = 56

    private var position: PlaceholderPosition = .bottom

    // MARK: - Lifecycle -

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    public override func layoutSubviews() {
        // Fixes an issue where left or right views are animated when a keyboard is shown and the textfield
        // has not yet finished it's initial layout phase.
        // This mainly happens when we want to animate keyboard appearance while textfield still might not be laid out
        // (e.g. during viewDidLoad)
        UIView.performWithoutAnimation {
            super.layoutSubviews()
        }
    }
}

// MARK: - Extensions -

// MARK: - Configuration

@available(iOS 14.0, *)
extension InputField {

    func configure(with configuration: InputFieldConfiguration) {
        textColor = configuration.textColor
        cursorColor = configuration.cursorColor
        placeholderColor = configuration.placeholderColor
        applyColorsFromConfiguration()
    }
}

// MARK: - UI setup

@available(iOS 14.0, *)
private extension InputField {

    func setupUI() {
        // Add views to hierarchy
        addSubview(textField)
        textField.addSubview(placeholderLabel)

        // Set constraints
        textFieldConstraints()

        // Appearance setup
        setupTextField()
        setupPlaceholderLabel()
    }

    func setupTextField() {
        textField.font = .systemFont(ofSize: 14)
        textField.didBecomeFirstResponder = { [unowned self] in
            inputFieldHeightConstraint.constant = mainHeight
            handlePlaceholder(isFirstResponder: true)
            UIView.animate(withDuration: animationSpeed, animations: { [self] in
                layoutIfNeeded()
            })
        }
        textField.didResignFirstResponder = { [unowned self] in
            inputFieldHeightConstraint.constant = mainHeight
            handlePlaceholder(isFirstResponder: false)
            UIView.animate(withDuration: animationSpeed, animations: { [self] in
                layoutIfNeeded()
            })
        }
        textField.didUpdateText = { [unowned self] text in
            inputFieldHeightConstraint.constant = mainHeight
            if text.isBlank, startsWithPlaceholderMinimized {
                movePlaceholder(position: .top)
            } else {
                handlePlaceholder(isFirstResponder: textField.isFirstResponder)
            }
        }
    }

    func setupPlaceholderLabel() {
        placeholderLabel.frame = CGRect(x: 0, y: paddingInactive, width: frame.width, height: 20)
        placeholderLabel.font = .systemFont(ofSize: 12)
    }

    func applyColorsFromConfiguration() {
        placeholderLabel.textColor = placeholderColor
        textField.textColor = textColor
        textField.tintColor = cursorColor
    }
}

// MARK: - Constraints setup

@available(iOS 14.0, *)
private extension InputField {

    enum PlaceholderPosition {
        case top, bottom
    }

    func textFieldConstraints() {
        textField.pinToSuperview()
        inputFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: mainHeight)
        inputFieldHeightConstraint.isActive = true
    }

    func handlePlaceholder(isFirstResponder: Bool) {
        let position: PlaceholderPosition = isFirstResponder || textField.text.isNotBlank ? .top : .bottom

        UIView.animate(
            withDuration: animationSpeed,
            delay: 0,
            options: .curveEaseOut,
            animations: { self.movePlaceholder(position: position) }
        )
    }

    func handlePlaceholder() {
        guard textField.text.isNotBlank else { return }

        UIView.animate(
            withDuration: animationSpeed,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.movePlaceholder(position: .top)
            }
        )
    }

    func movePlaceholder(position: PlaceholderPosition) {
        guard self.position != position else { return }

        placeholderLabel.transform = position == .top
            ? placeholderLabel.transform.scaledBy(x: 0.75, y: 0.75)
            : .identity

        placeholderLabel.frame = CGRect(
            x: 0,
            y: position == .top ? paddingActive : paddingInactive,
            width: placeholderLabel.frame.width,
            height: placeholderLabel.frame.height
        )
        self.position = position
    }
}

// MARK: - UITextFieldDelegate & DelegateProxy

@available(iOS 14.0, *)
public final class TextField: UITextField {

    // MARK: - Delegate helpers

    fileprivate var didBecomeFirstResponder: (() -> Void)?
    fileprivate var didResignFirstResponder: (() -> Void)?
    fileprivate var didUpdateText: ((String?) -> Void)?
    fileprivate var shouldClear: (() -> Void)?

    // MARK: - Private properties

    private var rightViewActionButton: UIButton? {
        rightView as? UIButton
    }

    // MARK: - Public properties

    var textPadding = UIEdgeInsets(top: 29, left: 0, bottom: 8, right: 0)

    // MARK: - Delegate proxy

    private let delegateProxy = TextFieldDelegateProxy()

    public override weak var delegate: UITextFieldDelegate? {
        get { return delegateProxy.userDelegate }
        set { delegateProxy.userDelegate = newValue }
    }

    // MARK: - Overrides

    public override var text: String? {
        didSet { didUpdateText?(text) }
    }

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.delegate = delegateProxy
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = delegateProxy
    }

    // MARK: - Overriden methods

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    // MARK: - Public methods

    func setupRightView(isSecureTextEntry: Bool, frame: CGRect) {
        if isSecureTextEntry {
            setupRevealSecureTextButton(frame: frame)
        } else {
            setupClearButton(frame: frame)
        }
    }

    // MARK: - File private methods

    fileprivate func updateTextPadding(bottom: CGFloat) {
        textPadding.bottom = bottom
    }

    // MARK: - TextFieldDelegateProxy

    final class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {

        // Delegate proxy handling
        weak var userDelegate: UITextFieldDelegate?

        override func responds(to aSelector: Selector!) -> Bool {
            return super.responds(to: aSelector) || userDelegate?.responds(to: aSelector) == true
        }

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            guard userDelegate?.responds(to: aSelector) == true else {
                return super.forwardingTarget(for: aSelector)
            }
            return userDelegate
        }

        // Delegate methods that proxy should forward
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            (textField as? TextField)?.didBecomeFirstResponder?()
            guard let userDelegate = userDelegate else { return true }
            return userDelegate.textFieldShouldBeginEditing?(textField) ?? true
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            (textField as? TextField)?.didResignFirstResponder?()
            guard let userDelegate = userDelegate else { return true }
            return userDelegate.textFieldShouldEndEditing?(textField) ?? true
        }
    }
}

// MARK: - UITextField right view setup

@available(iOS 14.0, *)
private extension TextField {

    func setupClearButton(frame: CGRect) {
        let action = UIAction { [unowned self] _ in
            self.text = nil
            _ = delegateProxy.userDelegate?.textFieldShouldClear?(self)
        }
        // Set up your own clear image
        configureRightViewAction(using: action, image: .remove, mode: .whileEditing, frame: frame)
    }

    func setupRevealSecureTextButton(frame: CGRect) {
        let action = UIAction { [unowned self] _ in
            isSecureTextEntry.toggle()

            // Set up your own images for secure text entry
            let image: UIImage = isSecureTextEntry ? .checkmark : .strokedCheckmark
            rightViewActionButton?.setImageAnimated(image: image, state: .normal, duration: 0.2)

            UISelectionFeedbackGenerator().prepareAndGenerateFeedback()
        }
        configureRightViewAction(using: action, image: .checkmark, mode: .always, frame: frame)
    }

    func configureRightViewAction(using action: UIAction, image: UIImage, mode: UITextField.ViewMode, frame: CGRect) {
        let size = CGSize(width: 24, height: 24)
        let padding: CGFloat = 16

        let x = frame.width - (size.width / 2) - padding
        let y = (frame.height / 2) - (size.height / 2)

        let rightViewButton = UIButton(frame: .init(x: x, y: y, width: size.width, height: size.height))
        rightViewButton.tintColor = .clear
        rightViewButton.setImage(image, for: .normal)
        rightViewButton.addAction(action, for: .touchUpInside)

        rightView = rightViewButton
        rightViewMode = mode
        clearButtonMode = .never
    }
}

// MARK: - BaseInputFieldInterface conformance

@available(iOS 14.0, *)
extension InputField: BaseInputFieldInterface {

    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    public var textPublisher: AnyPublisher<String?, Never> {
        textField.textPublisher
    }

    public func becomeFirstResponder() {
        textField.becomeFirstResponder()
    }
}
