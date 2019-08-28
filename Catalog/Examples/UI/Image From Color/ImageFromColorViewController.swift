//
//  ImageFromColorViewController.swift
//  Catalog
//
//  Created by Maroje Marcelić on 28/08/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class ImageFromColorViewController: UIViewController {
    
    private var _sampleView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _createSampleView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

private extension ImageFromColorViewController {
    
    func _createSampleView() {
        view.backgroundColor = .white
        
        let sampleView = UIButton(frame: .zero)
        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        
        let insets = UIEdgeInsets(top: 200, left: 50, bottom: -200, right: -50)
        sampleView.pinToSuperview(insets: insets)
        
        let normalImage = UIColor.red.image()
        let disabledImage = UIColor.green.image()
        sampleView.setBackgroundImage(normalImage, for: .normal)
        sampleView.setBackgroundImage(disabledImage, for: .selected)

        sampleView.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)

        _sampleView = sampleView
    }
    
    @objc func action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension ImageFromColorViewController: Catalogizable {
    
    static var title: String {
        return "Image from color"
    }
    
    static var viewController: UIViewController {
        return ImageFromColorViewController()
    }
}

