import XCTest
import Combine
@testable import Catalog

@available(iOS 13.0, *)
class TaskPublisherTests: XCTestCase {
    private var bag = Set<AnyCancellable>()

    func testCompletesWithoutError() {
        func work() async throws { }

        let publisher = ThrowingTaskPublisher(work)
        let expectation = expectation(description: "")

        publisher.sink(
            receiveCompletion: { event in
                expectation.fulfill()
                guard case .finished = event else {
                    XCTFail("Task should complete successfully")
                    return
                }
            },
            receiveValue: { _ in }
        )
        .store(in: &bag)

        waitForExpectations(timeout: 1)
    }

    func testCompletesWithError() {
        struct ErrorMock: Error { }
        func work() async throws { throw ErrorMock() }

        let publisher = ThrowingTaskPublisher(work)
        let expectation = expectation(description: "")

        publisher.sink(
            receiveCompletion: { event in
                expectation.fulfill()
                guard case .failure(let error) = event else {
                    XCTFail("Task should fail")
                    return
                }
                XCTAssertTrue(error is ErrorMock)
            },
            receiveValue: { _ in }
        )
        .store(in: &bag)

        waitForExpectations(timeout: 1)
    }

    func testTaskCancelledOnSubscriptionCancel() {
        let taskCancelled = PassthroughSubject<Void, Never>()
        let taskStartedExpectation = expectation(description: "Task Started")
        let taskCancelledExpectation = expectation(description: "Task Cancelled")
        taskCancelled.sink(
            receiveCompletion: { _ in },
            receiveValue: { taskCancelledExpectation.fulfill() }
        )
        .store(in: &bag)

        func work() async throws {
            taskStartedExpectation.fulfill()
            while true {
                await Task.yield()
                if Task.isCancelled { break }
            }
            taskCancelled.send(())
        }

        let publisher = ThrowingTaskPublisher(work)
        let subscription = publisher.sink(receiveCompletion: { _ in }, receiveValue: { })

        // Wait for task to be started before cancelling it
        wait(for: [taskStartedExpectation], timeout: 1)

        subscription.cancel()

        wait(for: [taskCancelledExpectation], timeout: 1)
    }
}
