//
//  Driver+Progressable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Shows loading on subscribe event
    func handleShowLoading(with progressable: Progressable) -> Driver<Element> {
        return self
            .do(onSubscribe: { [unowned progressable] in progressable.showLoading() })
    }
    
    /// Hides loading on first next event or completed event
    func handleHideLoading(with progressable: Progressable) -> Driver<Element> {
        return self
            .do(onNext: { [unowned progressable] _ in progressable.hideLoading() })
            .do(onCompleted: { [unowned progressable] in progressable.hideLoading() })
    }
    
    /// Shows loading on subscribe event and hides loading on
    /// first next event or completed event
    func handleLoading(with progressable: Progressable) -> Driver<Element> {
        return self
            .handleShowLoading(with: progressable)
            .handleHideLoading(with: progressable)
    }
    
}
