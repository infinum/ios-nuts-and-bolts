//
//  UIFeedbackGenerator+Utility.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit

public extension UISelectionFeedbackGenerator {

    func prepareAndGenerateFeedback() {
        prepare()
        selectionChanged()
    }
}

public extension UINotificationFeedbackGenerator {

    func prepareAndGenerateFeedback(for type: UINotificationFeedbackGenerator.FeedbackType) {
        prepare()
        notificationOccurred(type)
    }
}

public extension UIImpactFeedbackGenerator {

    func prepareAndGenerateFeedback() {
        prepare()
        impactOccurred()
    }
}
