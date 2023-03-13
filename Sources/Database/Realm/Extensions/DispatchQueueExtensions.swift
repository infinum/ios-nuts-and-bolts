import Foundation

extension DispatchQueue {
    /// Exclusive serial Realm database queue
    /// Everything realm related should be happening on this queue
    static let database = DispatchQueue(label: "com.infinum.realm")
}
