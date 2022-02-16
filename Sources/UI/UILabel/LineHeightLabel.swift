//
//  LineHeightLabel.swift
//  Catalog
//
//  Created by Damjan Dimovski on 15.2.22.
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public final class LineHeightLabel: UILabel {

    @IBInspectable public var lineHeight: CGFloat = 0.0

    override public func awakeFromNib() {
        super.awakeFromNib()
        setup(with: text)
    }

    override public var text: String? {
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
