//
//  Observable+Progressable.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    /// Shows loading on subscribe event.
    func handleShowLoading(with progressable: Progressable) -> Observable<E> {
        return self
            .do(onSubscribe: { [unowned progressable] in progressable.showLoading() })
    }
    
    /// Hides loading on next event or error event.
    func handleHideLoading(with progressable: Progressable) -> Observable<E> {
        return self
            .do(onNext: { [unowned progressable] _ in progressable.hideLoading() })
            .do(onError: { [unowned progressable] _ in progressable.hideLoading() })
    }
    
    /// Shows loading on subscribe event and hides loading on next event or error event.
    func handleLoading(with progressable: Progressable) -> Observable<E> {
        return self
            .handleShowLoading(with: progressable)
            .handleHideLoading(with: progressable)
    }
    
    /// Shows failure on error event.
    func handleShowFailure(with progressable: Progressable) -> Observable<E> {
        return self
            .do(onError: { [unowned progressable] in progressable.showFailure(with: $0) })
    }
    
    /// Shows loading on subscribe event, hides loading on next
    /// event or error event and shows failure on error event.
    func handleLoadingAndError(with progressable: Progressable) -> Observable<E> {
        return self
            .handleLoading(with: progressable)
            .handleShowFailure(with: progressable)
    }
    
}


