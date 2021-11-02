//
//  CombinePaging.swift
//  Catalog
//
//  Created by Zvonimir Medak on 28.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Combine

public enum PagingError: Error {
    case network
}
@available(iOS 13.0, *)
public enum CombinePaging {

    /// Simple pagination implementation in Combine. It defines how next page is loaded, how page is
    /// appended to last page, what is inital state and how events, like reload, next page are processed.
    ///
    /// Method defines two generic types: `Page` and `Container` where `Container` represents
    /// inital state where value from last `Page` is appened through `accumulator`, and `Page`
    /// represents single page, mostly response from the API. In most cases `Page` and `Container` will be
    /// of the same type, for examle `[SomeModel]`.
    /// - Parameter nextPage: Next page creator, here you can return API call publisher
    /// - Parameter containerCreator: Inital state for creator, common case empty array
    /// - Parameter accumulator: Define how page is appended to current state
    /// - Parameter hasNext: Decide when to stop querying for next page
    /// - Parameter event: Possible events: .reload, .nextPage, .update, .updateWithoutNextEvent
    /// - Parameter scheduler: Used only for tests
    public static func page<Page, Container>(
        make nextPage: @escaping (_ container: Container, _ lastPage: Page?) -> AnyPublisher<Page, PagingError>,
        startingWith containerCreator: @autoclosure @escaping () -> Container,
        joining accumulator: @escaping (_ container: Container, _ page: Page) -> Container,
        while hasNext: @escaping (_ container: Container, _ lastPage: Page) -> Bool,
        on event: AnyPublisher<Event<Container>, Never>,
        scheduler: Scheduler = .normal
    ) -> AnyPublisher<Response<Container>, PagingError> {
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

        let errorTypedEvent = event
            .setFailureType(to: PagingError.self)
            .eraseToAnyPublisher()

        let stateSubject = CurrentValueSubject<State<Container, Page>, PagingError>(initialState)
        // Forbid loading next page while current page is not loaded
        let loadingSubject = CurrentValueSubject<Bool, PagingError>(false)
        let filteredEvents = prepareEvent(errorTypedEvent, stateSubject: stateSubject, loadingSubject: loadingSubject)

        // We need receive(on:) for:
        // 1. Supporting feedback loop to avoid reentrancy issue, so scheduler must
        // be DispatchQueue.main
        // 2. Tests, where we inject TestScheduler since testing with async scheduler
        // is not possible
        let stateEvent = stateSubject.receive(on: scheduler.instance)

        // Wait for action before to finish and then go the next action
        // Simple use case is when user reloads list and while old list is visible
        // scrolls to bottom and starts loading next page
        let eventDriverState = filteredEvents.zip(stateEvent)

        let newState = eventDriverState
            .filter { event, state -> Bool in
                // If current event is next page, and there are no next pages
                // just ignore current event and prepare stateSubject to accpet
                // new items. stateSubject is inside zip, so it is very important to
                // reset state, otherwise it will block zip
                if event == .nextPage && !state.hasNext {
                    stateSubject.send(state)
                    return false
                }
                return true
            }
            .handleEvents(receiveOutput: { _ in loadingSubject.send(true) })
            .map { ($0.0, $0.1, pager) }
            .flatMap(loadNextPage)
            .handleEvents(receiveOutput: {
                stateSubject.send($0)
                loadingSubject.send(false)
            })
            .filter { $0.event?.shouldPropagateNextEvent ?? true }

        return newState.map { $0.response }.eraseToAnyPublisher()
    }

    /// Check `page` method for nore info, but what it does is load and accumulate all pages until
    /// `hasNext` returns false.
    public static func allPages<Page, Container>(
        make nextPage: @escaping (_ container: Container, _ lastPage: Page?) -> AnyPublisher<Page, PagingError>,
        startingWith containerCreator: @autoclosure @escaping () -> Container,
        joining accumulator: @escaping (_ container: Container, _ page: Page) -> Container,
        while hasNext: @escaping (_ container: Container, _ lastPage: Page) -> Bool,
        on event: AnyPublisher<Event<Container>, Never>,
        scheduler: CombinePaging.Scheduler = .normal
    ) -> AnyPublisher<Response<Container>, PagingError> {
        let nextPageSubject = PassthroughSubject<Void, Never>()
        let nextPageEvent = nextPageSubject
            .map { CombinePaging.Event<Container>.nextPage }
            .receive(on: scheduler.instance)

        return CombinePaging
            .page(
                make: nextPage,
                startingWith: containerCreator(),
                joining: accumulator,
                while: hasNext,
                on: event.merge(with: nextPageEvent).eraseToAnyPublisher(),
                scheduler: scheduler
            )
            .prefix(while: { !$0.hasNext })
            .handleEvents(receiveOutput: {
                if $0.hasNext {
                    nextPageSubject.send(())
                }
            })
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
public extension CombinePaging {

    enum Event<Container> {
        // Use on initial load or for refresh from start
        case reload
        // Load next page
        case nextPage
        // Update current container without invoking API call
        case update((Container) -> (Container))
        // Update current container without sending next
        // event through publisher pipe. It is useful when
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
        case tests(DispatchQueue)

        var instance: DispatchQueue {
            switch self {
            case .normal:
                return DispatchQueue.main
            case .tests(let scheduler): return scheduler
            }
        }
    }
}

@available(iOS 13.0, *)
private extension CombinePaging {

    struct State<Container, Page> {
        let container: Container
        let lastPage: Page?
        let hasNext: Bool
        let event: Event<Container>?

        var response: Response<Container> {
            return Response(container: container, hasNext: hasNext)
        }
    }

    static func prepareEvent<Page, Container>(
        _ event: AnyPublisher<Event<Container>, PagingError>,
        stateSubject: CurrentValueSubject<CombinePaging.State<Container, Page>, PagingError>,
        loadingSubject: CurrentValueSubject<Bool, PagingError>
    ) -> AnyPublisher<Event<Container>, PagingError> {
        let sharedEvent = event.share()
        // Avoid loading next page if reload is still in progress, to avoid
        // possible inconsistencies with data source, for example you already
        // loaded three pages, and you decide to reload, but reload takes some time,
        // you scroll down and request fourth page - that's the case we want to avoid
        let nextPageEvent = sharedEvent.filter {
            return $0 == .nextPage && stateSubject.value.hasNext && !loadingSubject.value
        }
        return  sharedEvent
            .filter { $0 == .reload }
            .merge(with: nextPageEvent, sharedEvent.filter { $0.isUpdate })
            .eraseToAnyPublisher()
    }

    static func loadNextPage<Container, Page>(
        event: Event<Container>,
        state: State<Container, Page>,
        pager: Pager<Container, Page>
    ) -> AnyPublisher<State<Container, Page>, PagingError> {
        // If event is not .reload or .nextPage then don't invoke an API
        // call and just modify container and last page if needed
        guard event.shouldPerformApiCall else {
            let container = event.modifiedContainer(
                from: state.container,
                containerCreator: pager.containerCreator
            )

            let lastPage = event.modifiedLastPage(from: state.lastPage)

            return CurrentValueSubject(
                State(
                    container: container,
                    lastPage: lastPage,
                    hasNext: state.hasNext,
                    event: event
                )
            )
                .eraseToAnyPublisher()
        }

        // If this is the last page and event is not reload
        // return current state
        if !state.hasNext && event == .nextPage {
            return CurrentValueSubject(state)
                .eraseToAnyPublisher()
        }

        // Depending on event create new container or append page to current container
        let container = event.modifiedContainer(
            from: state.container,
            containerCreator: pager.containerCreator
        )
        let lastPage = event.modifiedLastPage(from: state.lastPage)

        // Load next page
        let next = pager.nextPage(container, lastPage)

        // Map page event to new state to store information if there
        // is next page
        return next.map { page -> State<Container, Page> in
            let hasNextPage = pager.hasNext(container, page)
            let newContainer = pager.accumulator(container, page)
            return State(
                container: newContainer,
                lastPage: page,
                hasNext: hasNextPage,
                event: event
            )
        }
        .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
private struct Pager<Container, Page> {
    let nextPage: (_ container: Container, _ lastPage: Page?) -> AnyPublisher<Page, PagingError>
    let containerCreator: () -> Container
    let accumulator: (_ container: Container, _ page: Page) -> Container
    let hasNext: (_ container: Container, _ lastPage: Page) -> Bool
}

@available(iOS 13.0, *)
private extension CombinePaging.Event {

    func modifiedContainer(from container: Container, containerCreator: () -> Container) -> Container {
        switch self {
        case .nextPage: return container
        case .reload: return containerCreator()
        case .update(let updateClosure): return updateClosure(container)
        case .updateWithoutEvent(let updateClosure): return updateClosure(container)
        }
    }

    func modifiedLastPage<Model>(from lastPage: Model?) -> Model? {
        switch self {
        case .reload: return nil
        case .nextPage, .update, .updateWithoutEvent: return lastPage
        }
    }

    var shouldPerformApiCall: Bool {
        switch self {
        case .nextPage, .reload: return true
        case .update, .updateWithoutEvent: return false
        }
    }

    var shouldPropagateNextEvent: Bool {
        switch self {
        case .nextPage, .reload, .update: return true
        case .updateWithoutEvent: return false
        }
    }
}

@available(iOS 13.0, *)
extension CombinePaging.Event: Equatable {

    public static func == (lhs: CombinePaging.Event<Container>, rhs: CombinePaging.Event<Container>) -> Bool {
        switch (lhs, rhs) {
        case (.nextPage, .nextPage): return true
        case (.reload, .reload): return true
        case (.update, .update): return true
        default: return false
        }
    }
}

@available(iOS 13.0, *)
public extension CombinePaging.Response {

    static func none<T>() -> Paging.Response<[T]> {
        return Paging.Response(container: [], hasNext: false)
    }
}

@available(iOS 13.0, *)
extension CombinePaging.Response: Equatable where T: Equatable {

    public static func == (lhs: CombinePaging.Response<T>, rhs: CombinePaging.Response<T>) -> Bool {
        return lhs.hasNext == rhs.hasNext && lhs.container == rhs.container
    }
}
