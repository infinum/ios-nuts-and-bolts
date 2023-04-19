import Combine

/// A bridge between async await and Combine
/// It allows to convert async function to Combine publisher
public final class TaskPublisher<Success> {
    public typealias Work = () async -> Success
    private let work: Work

    public init(_ work: @escaping Work) {
        self.work = work
    }
}

@available(iOS 13.0, *)
extension TaskPublisher: Publisher {
    public typealias Output = Success
    public typealias Failure = Never

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        let subscription = Subscription<S>(work, downstream: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

@available(iOS 13.0, *)
extension TaskPublisher {
    actor Subscription<Downstream: Subscriber> where Downstream.Input == Output, Downstream.Failure == Never {
        let work: Work
        var task: Task<Void, Never>?
        var downstream: Downstream?

        init(_ work: @escaping Work, downstream: Downstream? = nil) {
            self.work = work
            self.downstream = downstream
        }

        func cleanup() {
            task = nil
            downstream = nil
        }

        func cancelAndCleanup() {
            task?.cancel()
            cleanup()
        }

        func receive(_ value: Output) {
            _ = downstream?.receive(value)
            downstream?.receive(completion: .finished)
            cleanup()
        }

        func runWork() {
            guard task == nil else { return }
            task = Task<Void, Never> { receive(await work()) }
        }
    }
}

@available(iOS 13.0, *)
extension TaskPublisher.Subscription: Subscription {
    nonisolated func request(_ demand: Subscribers.Demand) {
        guard demand > 0 else { return }
        Task<Void, Never> { await runWork() }
    }

    nonisolated func cancel() {
        Task<Void, Never> { await cancelAndCleanup() }
    }
}
