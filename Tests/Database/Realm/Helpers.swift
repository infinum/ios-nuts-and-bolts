import RealmSwift
@testable import Catalog

extension Realm.Configuration {
    static func inMemory(name: String) -> Realm.Configuration {
        Realm.Configuration(inMemoryIdentifier: name)
    }
}

class User: Object {
    @Persisted var name: String
    @Persisted var books: List<Book>
}

class Book: Object {
    @Persisted var name: String
    @Persisted var canDelete = true
}

extension Book: ValidatedDelete {
    var canBeRemovedFromRealm: Bool { canDelete }
}
