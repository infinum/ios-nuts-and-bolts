//
//  CombinePagingTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 03.11.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Combine
import CombineExt
@testable import Catalog

@available(iOS 13, *)
class CombinePagingTests: QuickSpec {

    typealias Container = [Int]
    typealias Page = [Int]
    typealias PagingPublisher = AnyPublisher<Container, PagingError>


    override func spec() {

        describe("testing paging") {

            var subscriptions = Set<AnyCancellable>()

            beforeEach {
                subscriptions = []
            }

            context("paging without next page or reload event") {
                it("should produce no events") {
                    let nextPage = AnyPublisher<CombinePaging.Event<Container>, Never>.create{ publisher in
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }
                    let reloadPage = AnyPublisher<CombinePaging.Event<Container>, Never>.create{ publisher in
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make: { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page -> Container in
                            return container + page
                        },
                        while: { _, _ -> Bool in
                            return false
                        },
                        on: Publishers.Merge(nextPage, reloadPage).eraseToAnyPublisher()
                    )

                    var count = 0

                    result
                        .count()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { count = $0 })
                        .store(in: &subscriptions)

                    expect(count).toEventually(equal(0), timeout: .seconds(5))
                }
            }

            context("paging with next page event") {
                it("should produce one next event") {
                    let events: AnyPublisher<CombinePaging.Event<Container>, Never> = .create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { _, _ -> Bool in
                            return false
                        },
                        on: events
                    )

                    let response = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []
                    var count = 0
                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    result
                        .count()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { count = $0 })
                        .store(in: &subscriptions)


                    expect(values).toEventually(equal([response]), timeout: .seconds(5))
                    expect(count).toEventually(equal(1), timeout: .seconds(5))
                }
            }

            context("paging with two next page events if there is no second page") {
                it("should produce one next event") {
                    let events: AnyPublisher<CombinePaging.Event<Container>, Never> = .create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(.nextPage)
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { _, _ -> Bool in
                            return false
                        },
                        on: events
                    )

                    let response = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []

                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([response]), timeout: .seconds(5))
                }
            }

            context("paging with two next page events if second page exits") {
                it("should produce two next events") {
                    let events: AnyPublisher<CombinePaging.Event<Container>, Never> = .create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(.nextPage)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return container.count < 5
                        },
                        on: events
                    )

                    let firstPage = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: true)
                    let secondPage = CombinePaging.Response(container: [1, 2, 3, 4, 5, 1, 2, 3, 4, 5], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []

                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([firstPage, secondPage]), timeout: .seconds(5))
                }
            }

            context("paging response none") {
                it("should not contain next page or elements") {
                    let response: CombinePaging.Response<Container> = .none()
                    expect(response.container).to(equal([]))
                    expect(response.hasNext).to(equal(false))
                }
            }

            context("paging update event") {
                it("should not invoke API call") {
                    let updateEvent: CombinePaging.Event<Container> = .update { container -> Container in
                        return container
                    }

                    let events = AnyPublisher<CombinePaging.Event<Container>, Never>.create { publisher in
                        publisher.send(updateEvent)
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    var apiCallInvoked = false

                    _ = CombinePaging.page(
                        make: { _, _ in
                            apiCallInvoked = true
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page -> Container in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return container.count < 5
                        },
                        on: events
                    )

                    expect(apiCallInvoked).to(equal(false))
                }
            }

            context("Paging with next page and update") {
                it("should produce one next and one completed event") {
                    let update: CombinePaging.Event<Container> = .update({ _ -> Container in
                        return [1, 2, 3]
                    })

                    let events = AnyPublisher<CombinePaging.Event<Container>, Never>.create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(update)
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return false
                        },
                        on: events
                    )

                    let firstPage = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let updateResponse = CombinePaging.Response(container: [1, 2, 3], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []

                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { print($0)
                                values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([firstPage, updateResponse]))
                }
            }

            context("paging update without next event") {
                it("should not send next event") {
                    let updateWithoutEvent: CombinePaging.Event<Container> = .updateWithoutEvent { _ in
                        return [1, 2, 3]
                    }

                    let events = AnyPublisher<CombinePaging.Event<Container>, Never>.create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(updateWithoutEvent)
                        publisher.send(completion: .finished)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return false
                        },
                        on: events
                    )

                    let firstPage = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []
                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([firstPage]))
                }
            }

            context("paging update without next event") {
                it("should persist changes to container") {
                    let updateWithoutEvent: CombinePaging.Event<Container> = .updateWithoutEvent({ _ -> Container in
                        return [1, 2, 3]
                    })
                    let update: CombinePaging.Event<Container> = .update { container in
                        return container
                    }

                    let events = AnyPublisher<CombinePaging.Event<Container>, Never>.create { publisher in
                        publisher.send(.nextPage)
                        publisher.send(updateWithoutEvent)
                        publisher.send(update)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.page(
                        make:  { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return false
                        },
                        on: events
                    )

                    let firstPage = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let updateResponse = CombinePaging.Response(container: [1, 2, 3], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []

                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([firstPage, updateResponse]), timeout: .seconds(10))
                }
            }

            context("paging all pages") {
                it("should fetch all pages") {
                    let events = AnyPublisher<CombinePaging.Event<Container>, Never>.create { publisher in
                        publisher.send(.reload)
                        return AnyCancellable{}
                    }

                    let result = CombinePaging.allPages(
                        make: { _, _ in
                            return Just<Container>([1, 2, 3, 4, 5])
                                .setFailureType(to: PagingError.self)
                                .eraseToAnyPublisher()
                        },
                        startingWith: [Int](),
                        joining: { container, page in
                            return container + page
                        },
                        while: { container, _ -> Bool in
                            return container.count < 5
                        },
                        on: events
                    )

                    let firstPage = CombinePaging.Response(container: [1, 2, 3, 4, 5], hasNext: true)
                    let secondPage = CombinePaging.Response(container: [1, 2, 3, 4, 5, 1, 2, 3, 4, 5], hasNext: false)
                    var values: [CombinePaging.Response<Container>] = []

                    result
                        .materialize()
                        .values()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { values.append($0) })
                        .store(in: &subscriptions)

                    expect(values).toEventually(equal([firstPage, secondPage]), timeout: .seconds(5))
                }
            }
        }
    }
}
