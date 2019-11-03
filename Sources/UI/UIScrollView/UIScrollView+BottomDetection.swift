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

    func reachedBottomOnceWith(restart: Driver<Void>, offset: CGFloat = 200.0) -> Driver<Void> {
        return restart
            .startWith(())
            .flatMapLatest { [unowned base] in return base.rx.reachedBottomOnce(offset: offset) }
    }

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

