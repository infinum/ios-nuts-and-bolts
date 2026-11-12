//
//  UILayoutGuide.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

/// Enum that represents four most used layout guides of a UIView.
public enum LayoutGuideKind {
    /// A layout guide representing an area with a readable width within the view.
    case readableWidth
    /// A layout guide representing the view’s margins.
    case layoutMargin
    /// The layout guide representing the portion of your view that is unobscured by bars and other content.
    case safeArea
    /// The layout guide representing view's edges.
    case edge
}

extension UILayoutGuide {

    /// Best guess for this layout guide kind
    var layoutGuideKind: LayoutGuideKind? {
        switch identifier {
        case "UIViewSafeAreaLayoutGuide": return .safeArea
        case "UIViewLayoutMarginsGuide": return .layoutMargin
        case "UIViewReadableContentGuide": return .readableWidth
        default: return nil
        }
    }
}
