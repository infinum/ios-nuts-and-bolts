//
//  Paging.swift
//
//  Created by Filip Gulan on 07/09/2018.
//  Copyright © 2018 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public enum Paging {
    
    /// Simple pagination implementation in RxSwift. It defines how next page is loaded, how page is
    /// appended to last page, what is inital state and how events, like reload, next page are processed.
    ///
    /// Method defines two generic types: `Page` and `Container` where `Container` represents
    /// inital state where value from last `Page` is appened through `accumulator`, and `Page`
    /// represents single page, mostly response from the API. In most cases `Page` and `Container` will be
    /// of the same type, for examle `[SomeModel]`.
    /// - Parameter nextPage: Next page creator, here you can return API call observable
    /// - Parameter containerCreator: Inital state for creator, common case empty array
    /// - Parameter accumulator: Define how page is appended to current state
    /// - Parameter hasNext: Decide when to stop querying for next page
    /// - Parameter event: Possible events: .reload, .nextPage, .update, .updateWithoutNextEvent
    /// - Parameter scheduler: Used only for tests
    public static func page<Page, Container>(
        make nextPage: @escaping (_ container: Container, _ lastPage: Page?) -> Single<Page>,
        startingWith containerCreator: @autoclosure @escaping () -> Container,
        joining accumulator: @escaping (_ container: Container, _ page: Page) -> Container,
        while hasNext: @escaping (_ container: Container, _ lastPage: Page) -> Bool,
        on event: Observable<Event<Container>>,
        scheduler: Scheduler = .normal
    ) -> Observable<Response<Container>> {
        let initialState = State<Container, Page>(
            container: containerCreator(),
            lastPage: nil,
            hasNext: true,
            event: nil
        )

        let pager = Pager(
            nextPage: nextPage,
            containerCreator: containerCreator,
            accumulator: accumulator,
            hasNext: hasNext
        )

        let stateRelay = BehaviorRelay(value: initialState)
        // Forbbid loading next page while current page is not loaded
        let loadingRelay = BehaviorRelay(value: false)
        let filteredEvents = _prepareEvent(event, stateRelay: stateRelay, loadingRelay: loadingRelay)

        // We need observeOn for:
        // 1. Supporting feedback loop to avoid reentrancy issue, so scheduler must
        // be MainScheduler.asyncInstance
        // 2. Tests, where we inject TestScheduler since testing with async scheduler
        // is not possible
        let stateEvent = stateRelay.observeOn(scheduler.instance)

        // Wait for action before to finish and then go the next action
        // Simple use case is when user reloads list and while old list is visible
        // scrolls to bottom and starts loading next page
        let eventDriverState = Observable.zip(filteredEvents, stateEvent)

        let newState = eventDriverState
            .filter { (event, state) -> Bool in
                // If current event is next page, and there are no next pages
                // just ignore current event and prepare stateRelay to accpet
                // new items. stateRelay is inside zip, so it is very important to
                // reset state, otherwise it will block zip
                if event == .nextPage && !state.hasNext {
                    stateRelay.accept(state)
                    return false
                }
                return true
            }
            .do(onNext: { _ in loadingRelay.accept(true) })
            .map { ($0.0, $0.1, pager) }
            .flatMapLatest(_loadNextPage)
            .do(onNext: {
                stateRelay.accept($0)
                loadingRelay.accept(false)
            })
            .filter { $0.event?._shouldPropagateNextEvent ?? true }

        return newState.map { $0.response }
    }
    
    /// Check `page` method for nore info, but what it does is load and accumulate all pages until
    /// `hasNext` returns false.
    public static func allPages<Page, Container>(
        make nextPage: @escaping (_ container: Container, _ lastPage: Page?) -> Single<Page>,
        startingWith containerCreator: @autoclosure @escaping () -> Container,
        joining accumulator: @escaping (_ container: Container, _ page: Page) -> Container,
        while hasNext: @escaping (_ container: Container, _ lastPage: Page) -> Bool,
        on event: Observable<Event<Container>>,
        scheduler: Scheduler = .normal
    ) -> Observable<Response<Container>> {
        let nextPageRelay = PublishRelay<Void>()
        let nextPageEvent = nextPageRelay
            .mapTo(Paging.Event<Container>.nextPage)
            .observeOn(scheduler.instance)

        return Paging
            .page(
                make: nextPage,
                startingWith: containerCreator(),
                joining: accumulator,
                while: hasNext,
                on: Observable.merge(event, nextPageEvent),
                scheduler: scheduler
            )
            .takeUntil(.inclusive) { !$0.hasNext }
            .do(onNext: {
                if $0.hasNext {
                    nextPageRelay.accept(())
                }
            })
    }
}

public extension Paging {
    
    enum Event<Container> {
        // Use on initial load or for refresh from start
        case reload
        // Load next page
        case nextPage
        // Update current container without invoking API call
        case update((Container) -> (Container))
        // Update current container without sending next
        // event through observable pipe. It is useful when
        // you have some kind of direct UI update like favorite
        // which you need to store in model but you'll handle
        // UI update manually
        case updateWithoutEvent((Container) -> (Container))

        var isUpdate: Bool {
            switch self {
            case .updateWithoutEvent, .update: return true
            case .reload, .nextPage: return false
            }
        }
    }

    struct Response<T> {
        public let container: T
        public let hasNext: Bool
    }
    
    enum Scheduler {
        case normal
        case tests(ImmediateSchedulerType)
        
        var instance: ImmediateSchedulerType {
            switch self {
            case .normal:
                return MainScheduler.asyncInstance
            case .tests(let scheduler): return scheduler
            }
        }
    }
}

private extension Paging {
    
    struct State<Container, Page> {
        let container: Container
        let lastPage: Page?
        let hasNext: Bool
        let event: Event<Container>?

        var response: Response<Container> {
            return Response(container: container, hasNext: hasNext)
        }
    }
    
    static func _prepareEvent<Page, Container>(
        _ event: Observable<Event<Container>>,
        stateRelay: BehaviorRelay<Paging.State<Container, Page>>,
        loadingRelay: BehaviorRelay<Bool>
    ) -> Observable<Event<Container>> {
        let sharedEvent = event.share(replay: 1, scope: .whileConnected)
        // Avoid loading next page if reload is still in progress, to avoid
        // possible inconsistencies with data source, for example you already
        // loaded three pages, and you decide to reload, but reload takes some time,
        // you scroll down and request fourth page - that's the case we want to avoid
        let nextPageEvent = sharedEvent.filter {
            return $0 == .nextPage && stateRelay.value.hasNext && !loadingRelay.value
        }
        return Observable
            .merge(
                sharedEvent.filter { $0 == .reload },
                nextPageEvent,
                sharedEvent.filter { $0.isUpdate }
            )
    }
    
    static func _loadNextPage<Container, Page>(
        event: Event<Container>,
        state: State<Container, Page>,
        pager: Pager<Container, Page>
    ) -> Observable<State<Container, Page>> {
        // If event is not .reload or .nextPage then don't invoke an API
        // call and just modify container and last page if needed
        guard event._shouldPerformApiCall else {
            let container = event._modifiedContainer(from: state.container,
                                                     containerCreator: pager.containerCreator)
            let lastPage = event._modifiedLastPage(from: state.lastPage)
            return Observable
                .just(State(
                    container: container, lastPage: lastPage,
                    hasNext: state.hasNext, event: event
                )
            )
        }

        // If this is the last page and event is not reload
        // return current state
        if !state.hasNext && event == .nextPage {
            return Observable.just(state)
        }

        // Depending on event create new container or append page to current container
        let container = event._modifiedContainer(
            from: state.container,
            containerCreator: pager.containerCreator
        )
        let lastPage = event._modifiedLastPage(from: state.lastPage)

        // Load next page
        let next = pager.nextPage(container, lastPage).asObservable()

        // Map page event to new state to store information if there
        // is next page
        return next.map { page -> State<Container, Page> in
            let hasNextPage = pager.hasNext(container, page)
            let newContainer = pager.accumulator(container, page)
            return State(
                container: newContainer, lastPage: page,
                hasNext: hasNextPage, event: event
            )
        }
    }
}

private struct Pager<Container, Page> {
    let nextPage: (_ container: Container, _ lastPage: Page?) -> Single<Page>
    let containerCreator: () -> Container
    let accumulator: (_ container: Container, _ page: Page) -> Container
    let hasNext: (_ container: Container, _ lastPage: Page) -> Bool
}

private extension Paging.Event {

    func _modifiedContainer(from container: Container, containerCreator: () -> Container) -> Container {
        switch self {
        case .nextPage: return container
        case .reload: return containerCreator()
        case .update(let updateClosure): return updateClosure(container)
        case .updateWithoutEvent(let updateClosure): return updateClosure(container)
        }
    }

    func _modifiedLastPage<Model>(from lastPage: Model?) -> Model? {
        switch self {
        case .reload: return nil
        case .nextPage, .update, .updateWithoutEvent: return lastPage
        }
    }

    var _shouldPerformApiCall: Bool {
        switch self {
        case .nextPage, .reload: return true
        case .update, .updateWithoutEvent: return false
        }
    }

    var _shouldPropagateNextEvent: Bool {
        switch self {
        case .nextPage, .reload, .update: return true
        case .updateWithoutEvent: return false
        }
    }
}

extension Paging.Event: Equatable {

    public static func == (lhs: Paging.Event<Container>, rhs: Paging.Event<Container>) -> Bool {
        switch (lhs, rhs) {
        case (.nextPage, .nextPage): return true
        case (.reload, .reload): return true
        case (.update, .update): return true
        default: return false
        }
    }
}

public extension Paging.Response {

    static func none<T>() -> Paging.Response<[T]> {
        return Paging.Response(container: [], hasNext: false)
    }
}

extension Paging.Response: Equatable where T: Equatable {

    public static func == (lhs: Paging.Response<T>, rhs: Paging.Response<T>) -> Bool {
        return lhs.hasNext == rhs.hasNext && lhs.container == rhs.container
    }
}
