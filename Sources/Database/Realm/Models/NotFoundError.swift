import Foundation

struct NotFoundError: LocalizedError {
    let type: String
    let id: String

    init(type: CustomStringConvertible? = nil, id: Any? = nil) {
        self.type = String(describing: type)
        self.id = String(describing: id as? CustomStringConvertible)
    }

    var errorDescription: String? {
        "NotFoundError: \(type) \(id)"
    }
}
