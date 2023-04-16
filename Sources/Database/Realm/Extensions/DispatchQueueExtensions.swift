import Foundation
import Combine

extension DispatchQueue {
    /// Exclusive serial Realm database queue
    /// Everything realm related should be happening on this queue
    static let database = DispatchQueue(label: "com.infinum.realm")
}

@available(iOS 13.0, *)
extension DispatchQueue {
    /// Helper function that creates a `Future` ensuring
    /// the work is executed on this `DispatchQueue`
    /// Useful when running some Realm work and providing Combine API
    func asyncFuture<T>(
        _ block: @escaping (@escaping Future<T, Error>.Promise) -> Void
    ) -> Future<T, Error> {
        return Future { [unowned self] promise in
            self.async { block(promise) }
        }
    }

    /// Helper function that creates a async function ensuring
    /// the work is executed on this `DispatchQueue`
    /// Useful when running some Realm work and providing async await API
    func asyncTask<T>(
        _ block: @escaping () throws -> T
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.async {
                let result = Result { try block() }
                continuation.resume(with: result)
            }
        }
    }
}
