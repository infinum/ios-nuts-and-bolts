// Copyright (c) Philips Domestic Appliances Nederland B.V 2022
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit

// MARK: - Compression Resistance And Hugging Priority

public extension UIView {

    /// Get or set the horizontal Content Compression Resistance Priority
    var horizontalCompressionResistance: UILayoutPriority {
        get { contentCompressionResistancePriority(for: .horizontal) }
        set { setContentCompressionResistancePriority(newValue, for: .horizontal) }
    }

    /// Get or set the vertical Content Compression Resistance Priority
    var verticalCompressionResistance: UILayoutPriority {
        get { contentCompressionResistancePriority(for: .vertical) }
        set { setContentCompressionResistancePriority(newValue, for: .vertical) }
    }

    /// Get or set the horizontal Hugging Priority
    var horizontalHuggingPriority: UILayoutPriority {
        get { contentHuggingPriority(for: .horizontal) }
        set { setContentHuggingPriority(newValue, for: .horizontal) }
    }

    /// Get or set the vertical Hugging Priority
    var verticalHuggingPriority: UILayoutPriority {
        get { contentHuggingPriority(for: .vertical) }
        set { setContentHuggingPriority(newValue, for: .vertical) }
    }
}

extension UILayoutPriority: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int

    /// Allows UILayoutPriority to be portrayed with integer literal
    ///
    /// Example
    /// ```
    /// label.horizontalHuggingPriority = 900
    /// ```
    public init(integerLiteral value: IntegerLiteralType) {
        self = value == 1_000 ? .required : .init(.init(value))
    }
}
