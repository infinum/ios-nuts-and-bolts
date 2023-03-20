import XCTest
import RealmSwift
@testable import Catalog

@available(iOS 14.0, *)
class DatabaseTests: XCTestCase {

    // Smoke test that we can successfully open the database
    func testOpeningDatabaseDoesntThrow() throws {
        let configuration = try Database.defaultConfiguration()

        XCTAssertNoThrow(try Database(configuration: configuration))
    }

    func testCreateAndRead() async throws {
        let database = try Database(configuration: .inMemory(name: name))

        try await database.createOrUpdate(UserDB.self, with: User(id: "test", name: ""))

        let user = try await database.read(UserDB.self, id: "test")
        XCTAssertEqual(user.id, "test")
    }

    func testReadThrowsAnError() async throws {
        let database = try Database(configuration: .inMemory(name: name))

        await XCTAssertThrowsErrorAsync(try await database.read(UserDB.self, id: "test"))
    }

    func testReadOptionalReturnsNil() async throws {
        let database = try Database(configuration: .inMemory(name: name))

        let user = try await database.readOptional(UserDB.self, id: "test")
        XCTAssertNil(user)
    }

    func testCreateAndThenUpdate() async throws {
        let database = try Database(configuration: .inMemory(name: name))

        try await database.createOrUpdate(UserDB.self, with: User(id: "test", name: "Initial"))
        try await database.createOrUpdate(UserDB.self, with: User(id: "test", name: "Changed"))

        let user = try await database.read(UserDB.self, id: "test")
        XCTAssertEqual(user.id, "test")
        XCTAssertEqual(user.name, "Changed")
    }

    func testObserveNameChange() async throws {
        let database = try Database(configuration: .inMemory(name: name))
        try await database.createOrUpdate(UserDB.self, with: User(id: "test", name: "Initial"))
        let expectation = self.expectation(description: "Name observer")

        var nameEvents: [String] = []
        let cancellable = database
            .observe(dbModel: UserDB.self, id: "test", mapping: \.asModel)
            .sink {
                nameEvents.append($0.name)
                if nameEvents.count == 2 { expectation.fulfill() }
            }
        _ = cancellable

        try await database.update(UserDB.self, with: User(id: "test", name: "Changed"))

        await waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(nameEvents, ["Initial", "Changed"])
    }
}
