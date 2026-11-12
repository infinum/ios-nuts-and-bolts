//
//  UIFeedbackGenerator+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import UIKit
import Combine

@available(iOS 13.0, *)
public extension Publisher {

    /// Adds haptic feedback once output has been received
    func selectionHapticFeedback() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in UISelectionFeedbackGenerator().prepareAndGenerateFeedback() })
    }

    /// Adds haptic feedback once output has been received
    func successHapticFeedback() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in UINotificationFeedbackGenerator().prepareAndGenerateFeedback(for: .success) })
    }

    /// Adds haptic feedback once output has been received
    func failureHapticFeedback() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in UINotificationFeedbackGenerator().prepareAndGenerateFeedback(for: .error) })
    }

    /// Adds haptic feedback once output has been received for a specified intensity
    func impactHapticFeedback(for intensity: CGFloat? = nil) -> Publishers.HandleEvents<Self> {
        if let intensity = intensity {
            return handleEvents(receiveOutput: { _ in UIImpactFeedbackGenerator().impactOccurred(intensity: intensity) })
        } else {
            return handleEvents(receiveOutput: { _ in UIImpactFeedbackGenerator().impactOccurred() })
        }
    }
}
