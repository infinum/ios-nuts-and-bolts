import RealmSwift

class BookDB: Object {
    @Persisted var name: String
    @Persisted var canDelete = true
}

extension BookDB: ValidatedDelete {
    var canBeRemovedFromRealm: Bool { canDelete }
}
