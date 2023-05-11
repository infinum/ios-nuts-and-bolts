import RealmSwift
@testable import Catalog

extension Realm.Configuration {
    static func inMemory(name: String) -> Realm.Configuration {
        Realm.Configuration(inMemoryIdentifier: name)
    }
}

public struct User: Identifiable {
    public let id: String
    public let name: String
}

extension UserDB: ModelMapped {
    public func update(with model: User, realm: Realm?) {
        updateIfNotInserted { self.id = model.id }
        name = model.name
    }

    public var asModel: User {
        User(id: id, name: name)
    }
}
