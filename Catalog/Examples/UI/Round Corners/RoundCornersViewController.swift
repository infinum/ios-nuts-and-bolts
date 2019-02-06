//
//  RoundCornersViewController.swift
//  Catalog
//
//  Created by Filip Gulan on 06/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class RoundCornersViewController: UIViewController {

    private var _sampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _createSampleView()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _sampleView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
}

private extension RoundCornersViewController {
    
    func _createSampleView() {
        view.backgroundColor = .white
        
        let sampleView = UIView(frame: .zero)
        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        
        let insets = UIEdgeInsets(top: 200, left: 50, bottom: -100, right: -50)
        sampleView.pinToSuperview(insets: insets)
        
        sampleView.backgroundColor = .green
        
        sampleView.layer.masksToBounds = true
        sampleView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        _sampleView = sampleView
    }
    
}

extension RoundCornersViewController: Catalogizable {
    
    static var title: String {
        return "Rounded corners"
    }
    
    static var viewController: UIViewController {
        return RoundCornersViewController()
    }
    
}
