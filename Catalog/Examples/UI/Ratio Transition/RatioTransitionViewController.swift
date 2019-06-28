//
//  RatioTransitionViewController.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class RatioTransitionViewController: UIViewController {

    private lazy var _presentationManager = RatioPresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }

}

private extension RatioTransitionViewController {
    
    func _setupUI() {
        view.backgroundColor = .white
        
        // Button logic
        let showButton = UIButton(type: .system)
        view.addSubview(showButton)
        showButton.centerToSuperview()
        showButton.setTitle("Show ratio transition", for: .normal)
        
        showButton.addTarget(
            self,
            action: #selector(_showRatioPresentation),
            for: .touchUpInside
        )
    }
    
    @objc
    func _showRatioPresentation() {
        let dummyViewController = UIViewController()
        dummyViewController.view.backgroundColor = .green
        
        // Config
        _presentationManager.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        _presentationManager.shouldDismissOnTap = true
        _presentationManager.ratio = 0.4
        _presentationManager.animations = { (presentedView, transition) in
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
        dummyViewController.transitioningDelegate = _presentationManager
        
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
