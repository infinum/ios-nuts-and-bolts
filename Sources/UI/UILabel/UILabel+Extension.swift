//
//  UILabel+Extension.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

protocol UILabelInitializable: UILabel {}
extension UILabel: UILabelInitializable {}

extension UILabelInitializable {

    init(
        text: String?,
        textColor: UIColor? = nil,
        lines: Int? = nil,
        alignment: NSTextAlignment = .left,
        font: UIFont? = nil
    ) {
        self.init(frame: .zero)
        self.text = text
        self.textAlignment = alignment
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let lines = lines {
            self.numberOfLines = lines
        }
        if let font = font {
            self.font = font
        }
    }
}
