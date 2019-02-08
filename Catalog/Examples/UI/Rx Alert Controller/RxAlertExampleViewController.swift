//
//  RxAlertExampleViewController.swift
//  Catalog
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxAlertExampleViewController: UIViewController {

    @IBOutlet private weak var _button: UIButton!
    @IBOutlet private weak var _label: UILabel!
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configure()
    }

}

private extension RxAlertExampleViewController {
    
    func _configure() {
        _button.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?._handleShowAlert()
            })
            .disposed(by: _disposeBag)
    }
    
    func _handleShowAlert() {
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
            .drive(_label.rx.text)
            .disposed(by: _disposeBag)
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
