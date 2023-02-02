import XCTest
import RealmSwift
@testable import Catalog

class CascadeDeleteTests: XCTestCase {
    var realm: Realm!
    var user: User!

    override func setUpWithError() throws {
        try super.setUpWithError()
        realm = try Realm(configuration: .inMemory(name: name))
        user = try realm.write {
            let user = User()
            let book = Book()
            user.books.append(book)
            realm.add(user)
            return user
        }
        XCTAssertEqual(realm.objects(User.self).count, 1)
        XCTAssertEqual(realm.objects(Book.self).count, 1)
    }

    override func tearDownWithError() throws {
        realm = nil
        user = nil
        try super.tearDownWithError()
    }

    func testDeletesUserAndBooks() throws {
        try realm.write { user.books.forEach { $0.canDelete = true } }

        try realm.write { realm.cascadeDelete(user) }

        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(realm.objects(Book.self).count, 0)
    }

    func testDeletesUserButNotBooks() throws {
        try realm.write { user.books.forEach { $0.canDelete = false } }

        try realm.write { realm.cascadeDelete(user) }

        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(realm.objects(Book.self).count, 1)
    }
}
