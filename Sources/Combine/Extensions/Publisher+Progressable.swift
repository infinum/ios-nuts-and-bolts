//
//  Publisher+Progressable.swift
//  Catalog
//
//  Created by Zvonimir Medak on 23.11.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public extension Publisher {

    typealias HandleEvents<T: Publisher> = Publishers.HandleEvents<T>

    /// Shows loading on subscribe event.
    func handleShowLoading(with progressable: Progressable) -> HandleEvents<Self> {
        return self
            .handleEvents(receiveSubscription: { [unowned progressable] _ in progressable.showLoading() })
    }

    /// Hides loading on next event or error event.
    func handleHideLoading(with progressable: Progressable) -> HandleEvents<HandleEvents<Self>> {
        return self
            .handleEvents(receiveOutput: { [unowned progressable] _ in progressable.hideLoading() })
            .handleEvents(receiveCompletion: { [unowned progressable] _ in progressable.hideLoading() })
    }

    /// Shows loading on subscribe event and hides loading on next event or error event.
    func handleLoading(with progressable: Progressable) -> HandleEvents<HandleEvents<HandleEvents<Self>>> {
        return self
            .handleShowLoading(with: progressable)
            .handleHideLoading(with: progressable)
    }

    /// Shows failure on error event.
    func handleShowFailure(with progressable: Progressable) -> HandleEvents<Self> {
        return self
            .handleEvents(receiveCompletion: { [unowned progressable] completion in
                if case .failure(let error) = completion {
                    progressable.showFailure(with: error)
                }
            })
    }

    /// Shows loading on subscribe event, hides loading on next
    /// event or error event and shows failure on error event.
    func handleLoadingAndError(with progressable: Progressable) ->
    HandleEvents<HandleEvents<HandleEvents<HandleEvents<Self>>>> {
        return self
            .handleLoading(with: progressable)
            .handleShowFailure(with: progressable)
    }
}
