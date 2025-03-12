// Copyright (c) Philips Domestic Appliances Nederland B.V 2022
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit

public extension UIView {

    /// Indicates whether the horizontal size class is currently regular (e.g. iPad in fullscreen, or iPhone in landscape).
    var isWidthRegular: Bool { return traitCollection.horizontalSizeClass == .regular }

    /// Indicates whether the vertical size class is currently regular (e.g. portrait iPhone, or iPad in any dimension)
    var isHeightRegular: Bool { return traitCollection.verticalSizeClass == .regular }

    /// Indicates whether both dimensions are of regular size class
    var isInRegularRegularSizeClass: Bool {
        return isWidthRegular && isHeightRegular
    }
}
