import XCTest
import RealmSwift
@testable import Catalog

class CascadeDeleteTests: XCTestCase {
    var realm: Realm!
    var user: UserDB!

    override func setUpWithError() throws {
        try super.setUpWithError()
        realm = try Realm(configuration: .inMemory(name: name))
        user = try realm.write {
            let user = UserDB()
            let book = BookDB()
            user.books.append(book)
            realm.add(user)
            return user
        }
        XCTAssertEqual(realm.objects(UserDB.self).count, 1)
        XCTAssertEqual(realm.objects(BookDB.self).count, 1)
    }

    override func tearDownWithError() throws {
        realm = nil
        user = nil
        try super.tearDownWithError()
    }

    func testDeletesUserAndBooks() throws {
        try realm.write { user.books.forEach { $0.canDelete = true } }

        try realm.write { realm.cascadeDelete(user) }

        XCTAssertEqual(realm.objects(UserDB.self).count, 0)
        XCTAssertEqual(realm.objects(BookDB.self).count, 0)
    }

    func testDeletesUserButNotBooks() throws {
        try realm.write { user.books.forEach { $0.canDelete = false } }

        try realm.write { realm.cascadeDelete(user) }

        XCTAssertEqual(realm.objects(UserDB.self).count, 0)
        XCTAssertEqual(realm.objects(BookDB.self).count, 1)
    }
}
