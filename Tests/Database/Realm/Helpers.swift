import RealmSwift
@testable import Catalog

extension Realm.Configuration {
    static func inMemory(name: String) -> Realm.Configuration {
        Realm.Configuration(inMemoryIdentifier: name)
    }
}
