//
//  CombineProgressableViewController.swift
//  Catalog
//
//  Created by Zvonimir Medak on 23.11.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CombineExt

@available(iOS 13, *)
final class CombineProgressableViewController: UIViewController, Progressable {

    private var subscriptions: Set<AnyCancellable> = []
    private let inputSubject = ReplaySubject<String, ProgressableError>(bufferSize: 3)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initializeLoadingSubject()
        handleProgressable()
    }

}

@available(iOS 13, *)
private extension CombineProgressableViewController {

    func initializeLoadingSubject() {
        inputSubject
            .handleLoadingAndError(with: self)
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { print($0) }
            )
            .store(in: &subscriptions)
    }

    func handleProgressable() {
        // stop the spinner
//        inputSubject.send("Stop the spinner!")

        // receive a popup with a failure message
        inputSubject.send(completion: .failure(.failed))
    }
}

@available(iOS 13, *)
extension CombineProgressableViewController: Catalogizable {

    static var title: String {
        return "Combine Progressable"
    }

    static var viewController: UIViewController {
        return CombineProgressableViewController()
    }

}

private enum ProgressableError: Error {
    case failed
}
