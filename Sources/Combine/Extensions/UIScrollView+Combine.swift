//
//  UIScrollView+BottomDetectionCombine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 28.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit
import Combine

@available(iOS 13, *)
public extension UIScrollView {

    /// - Parameter restart: Signal when to restart internal state of latest content offset position
    /// - Parameter offset: Offset from bottom to treat as bottom edge. Value is sign agnostic.
    func reachedBottomOnceWith(restart: AnyPublisher<Void, Never>, offset: CGFloat = 200.0) -> AnyPublisher<Void, Never> {
        return restart
            .flatMap { [unowned self] _ in return reachedBottomPublisher(offset: offset) }
            .eraseToAnyPublisher()
    }
}
