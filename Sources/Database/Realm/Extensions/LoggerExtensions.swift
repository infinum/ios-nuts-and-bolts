import OSLog

@available(iOS 14.0, *)
extension Logger {
    static let realm = Logger(subsystem: "com.infinum.Realm", category: "Realm")
}
