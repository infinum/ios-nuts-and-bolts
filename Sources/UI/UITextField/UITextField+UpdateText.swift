//
//  UITextField+UpdateText.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public extension UITextField {

    func update(text: String?) {
        self.text = text
        sendActions(for: .valueChanged)
    }
}
