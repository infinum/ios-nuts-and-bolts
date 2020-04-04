//
//  FollowButton.swift
//  Catalog
//
//  Created by Domagoj Hustnjak on 4/4/20.
//  Copyright © 2020 Infinum. All rights reserved.
//

import UIKit

@IBDesignable final class FollowButton: UIButton {

    // MARK: - Public properties -

    var toggleState: ToggleState = .available(active: false)

    // MARK: - Private properties -

    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle -

    override func awakeFromNib() {
        configureActivityIndicator()
    }
}

// MARK: - Extensions -

extension FollowButton: Togglable {

    func toggle(with toggleState: ToggleState) {
        self.toggleState = toggleState

        switch toggleState {
        case .available(let active):
            activityIndicator.stopAnimating()
            let title = active ? "Following" : "Follow"
            setTitle(title, for: .normal)
            isHidden = false

        case .unavailable:
            isHidden = true

        case .inProgress:
            setTitle("", for: .normal)
            activityIndicator.startAnimating()
        }
    }
}

private extension FollowButton {

    func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .white)
        let buttonHeight = bounds.size.height
        let buttonWidth = bounds.size.width
        activityIndicator.center = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
        addSubview(activityIndicator)
    }
}
