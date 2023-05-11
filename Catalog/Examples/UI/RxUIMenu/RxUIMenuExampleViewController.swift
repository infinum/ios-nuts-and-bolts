//
//  RxUIMenuExampleViewController.swift
//  Catalog
//
//  Created by Sven Svetina on 14.03.2023..
//  Copyright (c) 2023 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

@available(iOS 15.0, *)
final class RxUIMenuExampleViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: RxUIMenuExamplePresenterInterface!

    // MARK: - Private properties -

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var label: UILabel!
    private var menu: RxUIMenu<String>?
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

@available(iOS 15.0, *)
extension RxUIMenuExampleViewController: RxUIMenuExampleViewInterface {
}

@available(iOS 15.0, *)
private extension RxUIMenuExampleViewController {

    func setupView() {
        createDropdownMenu()
        setLabel(title: menu?.selectedItem() ?? .empty())
    }
}

// MARK: - Helpers -

@available(iOS 15.0, *)
private extension RxUIMenuExampleViewController {

    func createDropdownMenu() {
        menuButton.showsMenuAsPrimaryAction = true
        menu = RxUIMenu<String>(children: [
            RxUIAction(title: "Ok", value: "Ok selected"),
            RxUIAction(title: "Cancel", attributes: .destructive, value: "Cancel selected"),
            RxUIAction(title: "Remove", image: .remove, value: "Remove selected")
        ])
        menuButton.menu = menu?.createUIMenu()
    }

    func setLabel(title: Signal<String>) {
        title
            .emit(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Catalogizable -

@available(iOS 15.0, *)
extension RxUIMenuExampleViewController: Catalogizable {

    static var title: String {
        return "UIMenu Button"
    }

    static var viewController: UIViewController {
        return RxUIMenuExampleWireframe().viewController
    }
}