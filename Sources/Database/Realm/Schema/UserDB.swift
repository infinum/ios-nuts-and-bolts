import RealmSwift

class UserDB: Object {
    @Persisted var name: String
    @Persisted var books: List<BookDB>
}
