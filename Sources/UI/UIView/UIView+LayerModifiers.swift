//
//  UIView+LayerModifiers.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 17/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public extension UIView {

    /// Adds border color to the view. Should be used in combination with `borderWidth`.
    ///
    /// This modificator can be used in combination with `borderWidth` and `cornerRadius` modificators.
    /// `borderColor` could be set from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap(UIColor.init)
        }
        set (newColor) {
            layer.borderColor = newColor?.cgColor
        }
    }

    /// Adds border width to the view with color from `borderColor`.
    ///
    /// This modificator can be used in combination with `borderColor` and `cornerRadius` modificators.
    /// `borderWidth` could be set from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set (newBorderWidth) { layer.borderWidth = newBorderWidth }
    }

    /// Adds corner radius to all corners of the view.
    ///
    /// This modificator can be used in combination with `borderColor` and `borderWidth` modificators.
    /// `cornerRadius` could be set from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set (newCornerRadious) {
            layer.masksToBounds = true
            layer.cornerRadius = newCornerRadious
        }
    }

    /// Adds a rectangular drop shadow to a view.
    ///
    /// This method allows you to configure your shadow exactly as the
    /// designer specified it in Figma or Sketch.
    ///
    /// - Parameters:
    ///   - color: The base color of the shadow. If not defined black color is used as is most often the case.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: The horizontal and vertical positioning of the shadow relative to the view.
    ///   - blur: The blur parameter as defined in Figma/Sketch.
    ///   - spread: The spread parameter as defined in Figma/Sketch.
    func applyFigmaShadow(
        color: UIColor = .black,
        opacity: Float,
        offset: CGSize = .zero,
        blur: CGFloat,
        spread: CGFloat = 0
    ) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offset
      layer.shadowRadius = blur / UIScreen.main.scale

      if spread == 0 {
        layer.shadowPath = nil
      } else {
        let dx = -spread
        let rect = bounds.insetBy(dx: dx, dy: dx)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
      }
    }
    
}
