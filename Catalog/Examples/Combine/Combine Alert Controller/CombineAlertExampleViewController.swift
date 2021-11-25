//
//  CombineAlertExampleViewController.swift
//  Catalog
//
//  Created by Zvonimir Medak on 24.11.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

@available(iOS 13, *)
class CombineAlertExampleViewController: UIViewController {

    @IBOutlet private var button: UIButton!
    @IBOutlet private var label: UILabel!
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

@available(iOS 13, *)
private extension CombineAlertExampleViewController {

    func configure() {
        button
            .tapPublisher
            .sink(receiveValue: { [unowned self] in
                handleShowAlert()
            })
            .store(in: &subscriptions)
    }

    func handleShowAlert() {
        let okAction = CombineAlertAction(title: "Ok", style: .default, value: "Ok")
        let cancelAction = CombineAlertAction(title: "Cancel", style: .cancel, value: "Cancel")
        let deleteAction = CombineAlertAction(title: "Delete", style: .destructive, value: "Delete")

        let selectedAction = UIAlertController.present(
            on: self,
            title: "Alert Demo",
            message: "Rx Alert Demo showcase",
            actions: [okAction, cancelAction, deleteAction],
            style: .alert
        )

        selectedAction
            .print("Actions")
            .map { "Selected action: \($0)" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: label)
            .store(in: &subscriptions)
    }

}

@available(iOS 13, *)
extension CombineAlertExampleViewController: Catalogizable {

    static var title: String {
        return "Combine Alert Controller"
    }

    static var viewController: UIViewController {

        return UIStoryboard(name: "CombineAlertExample", bundle: nil)
            .instantiateViewController(ofType: CombineAlertExampleViewController.self)
    }

}
