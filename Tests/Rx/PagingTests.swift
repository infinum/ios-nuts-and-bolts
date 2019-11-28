//
//  PagingTests.swift
//  CoreTests
//
//  Created by Filip Gulan on 30/09/2018.
//  Copyright © 2018 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxTest
import RxSwift
import RxRelay
@testable import Catalog

class PagingTests: QuickSpec {

    typealias Container = [Int]
    typealias Page = [Int]
    typealias ObservablePaging = Observable<Paging.Response<Container>>

    override func spec() {

        describe("testing paging") {
            var scheduler: TestScheduler!

            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
            }
            
            context("paging without next page or reload event") {
                it("shoudl produce no events") {
                    let nextPage: Observable<Paging.Event<Container>> = Observable.empty()
                    let reloadPage: Observable<Paging.Event<Container>> = Observable.empty()
                    
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (_, _) -> Bool in
                            return false
                        }, on: Observable.merge(nextPage, reloadPage), scheduler: .tests(scheduler))
                    }
                    expect(result.events.count).to(equal(0))
                }
            }

            context("paging with next page event") {
                it("should produce one next event") {
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (_, _) -> Bool in
                            return false
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let response = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages.count).to(equal(1))
                    expect(pages[0]).to(equal(response))
                }
            }

            context("paging with two next page events if there is no second page") {
                it("should not produce new next event") {
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage),
                            .next(11, Paging.Event<Container>.nextPage)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (_, _) -> Bool in
                            return false
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let response = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages.count).to(equal(1))
                    expect(pages[0]).to(equal(response))
                }
            }

            context("paging with two next page events if second page exists") {
                it("should produce two next events") {
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage),
                            .next(11, Paging.Event<Container>.nextPage)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return container.count < 5
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let firstPage = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: true)
                    let secondPage = Paging.Response(container: [1, 2, 3, 4, 5, 1, 2, 3, 4, 5], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages).to(equal([firstPage, secondPage]))
                }
            }

            context("paging response none") {
                it("should not containt next page or elements") {
                    let response: Paging.Response<Container> = .none()
                    expect(response.container) == []
                    expect(response.hasNext) == false
                }
            }
            
            context("paging update event") {
                it("should not invoke API call") {
                    let updateEvent: Paging.Event<Container> = Paging.Event<Container>.update({ container -> Container in
                        return container
                    })
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, updateEvent)
                        ])
                        .asObservable()
                    
                    var apiCallInvoked = false
                    _ = scheduler.start(created: 0, subscribed: 100, disposed: 10000, create: { () -> Observable<Paging.Response<Container>> in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            apiCallInvoked = true
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return container.count < 5
                        }, on: events)
                    })
                    
                    expect(apiCallInvoked) == false
                }
            }

            context("paging with next page and update") {
                it("should produce one next and one completed event") {
                    let update: Paging.Event<Container> = Paging.Event<Container>.update({ _ -> Container in
                        return [1, 2, 3]
                    })
                    
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage),
                            .next(11, update)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return false
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let firstPage = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let updateResponse = Paging.Response(container: [1, 2, 3], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages).to(equal([firstPage, updateResponse]))
                }
            }

            context("paging update without next event") {
                it("should not send next event") {
                    let updateWithoutEvent: Paging.Event<Container> = Paging.Event<Container>.updateWithoutEvent({ _ -> Container in
                        return [1, 2, 3]
                    })
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage),
                            .next(11, updateWithoutEvent)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return false
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let firstPage = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages).to(equal([firstPage]))
                }
            }

            context("paging update without next event") {
                it("should persist changes to container") {
                    let updateWithoutEvent: Paging.Event<Container> = Paging.Event<Container>.updateWithoutEvent({ _ -> Container in
                        return [1, 2, 3]
                    })
                    let update: Paging.Event<Container> = Paging.Event<Container>.update({ container -> Container in
                        return container
                    })
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.nextPage),
                            .next(12, updateWithoutEvent),
                            .next(12, update)
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.page(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return false
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let firstPage = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: false)
                    let updateResponse = Paging.Response(container: [1, 2, 3], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages).to(equal([firstPage, updateResponse]))
                }
            }

            context("paging all pages") {
                it("should fetch all pages") {
                    let events: Observable<Paging.Event<Container>> = scheduler
                        .createHotObservable([
                            .next(10, Paging.Event<Container>.reload),
                        ])
                        .asObservable()
                    let result = scheduler.startWithDefaultParams() { () -> ObservablePaging in
                        return Paging.allPages(make: { (container, page) -> Single<Page> in
                            return Single<Page>.just([1, 2, 3, 4, 5])
                        }, startingWith: [Int](), joining: { (container, page) -> Container in
                            return container + page
                        }, while: { (container, _) -> Bool in
                            return container.count < 5
                        }, on: events, scheduler: .tests(scheduler))
                    }
                    
                    let firstPage = Paging.Response(container: [1, 2, 3, 4, 5], hasNext: true)
                    let secondPage = Paging.Response(container: [1, 2, 3, 4, 5, 1, 2, 3, 4, 5], hasNext: false)
                    let pages = result.events.compactMap { $0.value.element }
                    expect(pages).to(equal([firstPage, secondPage]))
                }
            }
        }
    }
}

extension TestScheduler {
    
    public func startWithDefaultParams<Element>(_ create: @escaping () -> Observable<Element>) -> TestableObserver<Element> {
        return start(created: 0, subscribed: 1, disposed: 1000, create: create)
    }
}
