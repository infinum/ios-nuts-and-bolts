//
//  ToggleViewController.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import UIKit
import RxSwift

final class ToggleViewController: UIViewController {

    // MARK: - Outlets -

    @IBOutlet private var followButton: FollowButton!

    // MARK: - Public properties -

    var presenter: TogglePresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Extensions -

extension ToggleViewController: ToggleViewInterface {}

private extension ToggleViewController {

    func configure() {
        let output = Toggle.ViewOutput(currentState: followButton.tap)
        let input = presenter.configure(with: output)

        followButton.setup(with: input.newState).disposed(by: disposeBag)
    }
}

extension ToggleViewController: Catalogizable {

    static var title: String {
        return "Toggle Button"
    }

    static var viewController: UIViewController {
        return ToggleWireframe().viewController
    }
}
