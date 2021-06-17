//
//  RatioTransitionViewController.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class RatioTransitionViewController: UIViewController {

    private lazy var presentationManager = RatioPresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

private extension RatioTransitionViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Button logic
        let showButton = UIButton(type: .system)
        view.addSubview(showButton)
        showButton.centerToSuperview()
        showButton.setTitle("Show ratio transition", for: .normal)
        
        showButton.addTarget(
            self,
            action: #selector(showRatioPresentation),
            for: .touchUpInside
        )
    }
    
    @objc
    func showRatioPresentation() {
        let dummyViewController = UIViewController()
        dummyViewController.view.backgroundColor = .green
        
        // Config
        presentationManager.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        presentationManager.shouldDismissOnTap = true
        presentationManager.ratio = 0.4
        presentationManager.animations = { presentedView, transition in
            presentedView?.layer.masksToBounds = true

            let radius: CGFloat
            switch transition {
            case .present:
                radius = 16.0
            case .dismiss:
                radius = 0.0
            }
            presentedView?.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        }
        
        dummyViewController.modalPresentationStyle = .custom
        dummyViewController.transitioningDelegate = presentationManager
        
        present(dummyViewController, animated: true)
    }
    
}

extension RatioTransitionViewController: Catalogizable {

    static var title: String {
        return "Ratio Transition"
    }
    
    static var viewController: UIViewController {
        return RatioTransitionViewController()
    }
    
}
