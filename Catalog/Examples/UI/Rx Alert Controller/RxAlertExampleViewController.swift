//
//  RxAlertExampleViewController.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxAlertExampleViewController: UIViewController {

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var label: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

private extension RxAlertExampleViewController {
    
    func configure() {
        button.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.handleShowAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func handleShowAlert() {
        let okAction = AlertAction(title: "Ok", style: .default, value: "Ok")
        let cancelAction = AlertAction(title: "Cancel", style: .cancel, value: "Cancel")
        let deleteAction = AlertAction(title: "Delete", style: .destructive, value: "Delete")
        
        let selectedAction = UIAlertController.present(
            on: self,
            title: "Alert Demo",
            message: "Rx Alert Demo showcase",
            actions: [okAction, cancelAction, deleteAction],
            style: .alert
        )
        
        selectedAction
            .map { "Selected action: \($0)" }
            .asDriver(onErrorJustReturn: "Error")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }

}

extension RxAlertExampleViewController: Catalogizable {
    
    static var title: String {
        return "Rx Alert Controller"
    }
    
    static var viewController: UIViewController {
        return RxAlertExampleViewController()
    }
    
}
