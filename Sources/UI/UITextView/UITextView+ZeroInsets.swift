//
//  UITextView+ZeroInsets.swift
//
//  Created by Mario Galijot on 27/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit.UITextView

public extension UITextView {
    
    /// Removes all insets from a textView, so it can act more like a label.
    func removeAllInsets() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        contentInset = .zero
    }
}
