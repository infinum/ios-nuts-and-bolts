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

    func reachedBottomPublisher(offset: CGFloat = 200.0) -> AnyPublisher<Void, Never> {
        publisher(for: \.contentOffset)
            .map { [unowned self] _ in isNearBottomEdge(offset: offset) }
            .removeDuplicates()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    /// - Parameter restart: Signal when to restart internal state of latest content offset position
    /// - Parameter offset: Offset from bottom to treat as bottom edge. Value is sign agnostic.
    func reachedBottomOnceWith(restart: AnyPublisher<Void, Never>, offset: CGFloat = 200.0) -> AnyPublisher<Void, Never> {
        return restart
            .flatMap { _ in return self.reachedBottomPublisher(offset: offset) }
            .eraseToAnyPublisher()
    }
}
