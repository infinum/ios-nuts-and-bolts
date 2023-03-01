import XCTest
@testable import Catalog
import RealmSwift

final class RealmCRUDTests: XCTestCase {
    var realm: Realm!

    override func setUpWithError() throws {
        try super.setUpWithError()
        realm = try Realm(configuration: .inMemory(name: name))
    }

    override func tearDownWithError() throws {
        realm = nil
        try super.tearDownWithError()
    }

    func testFindExistingObject() throws {
        try realm.write {
            let user = UserDB()
            user.id = "test"
            realm.add(user)
            return user
        }

        XCTAssertNoThrow(
            try realm.findObject(of: UserDB.self, for: "test")
        )
    }

    func testFindExistingObjectWhenDoesntExist() throws {
        XCTAssertThrowsError(
            try realm.findObject(of: UserDB.self, for: "test")
        )
    }
}
