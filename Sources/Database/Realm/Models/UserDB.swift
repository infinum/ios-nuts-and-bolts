import RealmSwift

class UserDB: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var books: List<BookDB>
}
