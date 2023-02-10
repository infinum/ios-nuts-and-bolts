//
//  UIView+Blur.swift
//  Catalog
//
//  Created by Leo Leljak on 05.12.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Adds blurred view to the current view at BlurPosition with UIBlurEffect.Style
    ///
    /// - Parameters:
    ///   - style: Blur style available for blur effect
    ///   - position: BlurPosition at which blurEffectView will be inserted
    ///   - animated: Show blur overlay animated
    func blur(style: UIBlurEffect.Style = .regular, at position: BlurPosition, animated: Bool = false) {
        guard viewWithTag(position.rawValue) == nil else { return }
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.tag = position.rawValue
        blurEffectView.alpha = animated ? 0 : 1
        switch position {
        case .background: insertSubview(blurEffectView, at: 0)
        case .foreground: addSubview(blurEffectView)
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                blurEffectView.alpha = 1.0
            })
        }
    }
    
    /// Removes previously set blurred view (blur function)
    ///
    /// - Parameters:
    ///   - position: BlurPosition at which blurEffectView will be removed
    ///   - animated: Hide blur overlay animated
    func removeBlur(at position: BlurPosition, animated: Bool = false) {
        let blurEffectView = viewWithTag(position.rawValue)
        guard animated else {
            blurEffectView?.removeFromSuperview()
            return
        }
        UIView.animate(
            withDuration: 0.2,
            animations: { blurEffectView?.alpha = 0 },
            completion: { _ in blurEffectView?.removeFromSuperview() }
        )
    }
    
}
