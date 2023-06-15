//
//  InputFieldViewController.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright (c) 2022 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import CombineCocoa
import CombineExt

@available(iOS 14.0, *)
final class InputFieldViewController: UIViewController {

    @IBOutlet private weak var typingInputFieldView: InputFieldView!
    @IBOutlet private weak var passwordInputFieldView: InputFieldView!
    @IBOutlet private weak var tapOnlyInputFieldView: InputFieldView!
    @IBOutlet private weak var tappedLabel: UILabel!

    // MARK: - Private properties -

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

@available(iOS 14.0, *)
private extension InputFieldViewController {

    func setupView() {
        let tapRelay = PassthroughRelay<Void>()

        configureInputFields(with: tapRelay)

        handle(tapAction: tapRelay.asSignal())
    }
}

@available(iOS 14.0, *)
private extension InputFieldViewController {

    func configureInputFields(with tapRelay: PassthroughRelay<Void>) {
        typingInputFieldView.configure(with: .init(
            placeholderText: "Type away but less than 20 characters!",
            inputValidation: .init(validators: MaxValueLengthValidator(maxLength: 20), handle: .whileTyping)
        ))

        passwordInputFieldView.configure(with: .init(
            placeholderText: "Write your most secure password",
            isSecureTextEntry: true
        ))

        tapOnlyInputFieldView.configure(with: .init(
            placeholderText: "Tap only!!!",
            readOnly: true,
            startsWithPlaceholderMinimized: true,
            textChangedRelay: .init("Tap away!!!"),
            tapActionRelay: tapRelay
        ))
    }
}

// MARK: - Handlers

@available(iOS 14.0, *)
private extension InputFieldViewController {

    func handle(tapAction: CombineSignal<Void>) {
        tapAction
            .sink(receiveValue: { [unowned self] in tappedLabel.isHiddenInStackView.toggle() })
            .store(in: &cancellables)
    }
}

@available(iOS 14.0, *)
extension InputFieldViewController: Catalogizable {

    static var title: String {
        return "Input field"
    }

    static var viewController: UIViewController {
        return UIStoryboard(name: "InputField", bundle: nil)
            .instantiateViewController(ofType: InputFieldViewController.self)
    }
}
