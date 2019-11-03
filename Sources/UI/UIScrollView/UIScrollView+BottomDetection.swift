//
//  UIScrollView+BottomDetection.swift
//  Catalog
//
//  Created by Filip Gulan on 03/11/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public extension UIScrollView {
    
    /// Checks if the current postion of scroll view is near bottom with given offset.
    /// It is useful when implementing pagination and want start loading next page
    /// few points before user even reaches bottom.
    ///
    /// - Parameter offset: Offset from bottom to treat as bottom edge. Value is sign agnostic.
    func isNearBottomEdge(offset: CGFloat = 0) -> Bool {
        let visibleHeight = frame.height
            - contentInset.top
            - contentInset.bottom
        let currentY = contentOffset.y + contentInset.top
        let threshold = max(0.0, contentSize.height - visibleHeight)
        return currentY + abs(offset) > threshold
    }
}

public extension Reactive where Base: UIScrollView {
    
    /// Fires event when user reaches scroll view bottom for given offset. For more info check ` reachedBottomOnce(offset:)` method.
    /// Since this method uses scan and max, restart is used as a signal to reset internal scan state.
    /// It is useful in case when you have pull to refresh where you need to reset what vas the latest postion on bottom of scroll view.
    ///
    /// - Parameter restart: Signal when to restart internal state of latest content offset position
    /// - Parameter offset: Offset from bottom to treat as bottom edge. Value is sign agnostic.
    func reachedBottomOnceWith(restart: Driver<Void>, offset: CGFloat = 200.0) -> Driver<Void> {
        return restart
            .startWith(())
            .flatMapLatest { [unowned base] in return base.rx.reachedBottomOnce(offset: offset) }
    }
    
    /// Fires event when user reaches scroll view bottom for given offset. It uses content offset as measurement method so
    /// client should take care of case where content size changes.
    /// - Parameter offset: Offset from bottom to treat as bottom edge. Value is sign agnostic.
    func reachedBottomOnce(offset: CGFloat) -> Driver<Void> {
        return contentOffset
            .asDriver()
            .map { $0.y }
            .map(Int.init)
            .scan(0) { max($0, $1) }
            .skip(1)
            .distinctUntilChanged()
            .map { [weak base] _ -> Bool in
                guard let scrollView = base else { return false }
                return scrollView.isNearBottomEdge(offset: offset)
            }
            .distinctUntilChanged()
            .flatMap { $0 ? .just(()) : .empty() }
    }
}

