//
//  LineHeightLabel.swift
//  Catalog
//
//  Created by Damjan Dimovski on 15.2.22.
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

final class LineHeightLabel: UILabel {

    @IBInspectable var lineHeight: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        setup(with: text)
    }

    override var text: String? {
        didSet { setup(with: text) }
    }

    var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        paragraphStyle.alignment = textAlignment
        return paragraphStyle
    }

    func setup(with text: String?) {
        guard let font = font, let textColor = textColor else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: textColor
        ]

        attributedText = NSMutableAttributedString(string: text ?? "", attributes: attributes)
    }
}
