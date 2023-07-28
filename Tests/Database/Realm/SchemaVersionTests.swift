import XCTest
@testable import Catalog
import RealmSwift
import Realm

@available(iOS 14.0, *)
class SchemaVersionTests: XCTestCase {
    var migrations: [SchemaVersion: (Migration) -> Void]!
    var v0MigrationExecuted = false
    var v1MigrationExecuted = false

    override func setUpWithError() throws {
        try super.setUpWithError()
        migrations = [
            SchemaVersion.v0: { _ in self.v0MigrationExecuted = true },
            SchemaVersion.v1: { _ in self.v1MigrationExecuted = true }
        ]
    }

    func testToSameVersionDoesntExecuteMigrations() throws {
        let sameVersionPairs: [(SchemaVersion, SchemaVersion)] = [(.v0, .v0), (.v1, .v1)]

        for (from, to) in sameVersionPairs {
            SchemaVersion.execute(
                migration: Migration(),
                from: from,
                to: to,
                migrations: migrations
            )
            XCTAssertFalse(v0MigrationExecuted)
            XCTAssertFalse(v1MigrationExecuted)
        }
    }

    func testToOlderVersionDoesntExecuteMigrations() throws {
        SchemaVersion.execute(
            migration: Migration(),
            from: .v1,
            to: .v0,
            migrations: migrations
        )
        XCTAssertFalse(v0MigrationExecuted)
        XCTAssertFalse(v1MigrationExecuted)
    }

    func testToNewerVersionExecutesOnlyNewerMigrations() throws {
        SchemaVersion.execute(
            migration: Migration(),
            from: .v0,
            to: .v1,
            migrations: migrations
        )
        XCTAssertFalse(v0MigrationExecuted)
        XCTAssertTrue(v1MigrationExecuted)
    }

    // This serves as a smoke test that runs all migrations on inital version of the database (v0)
    // You are encouraged to create separate tests for each of versions that you add.
    func testPerformAllMigrations() throws {
        /*
         ```
         var configuration = try Database.defaultConfiguration()
         URL pointing to snapshot of initial version of the DB
         configuration.fileURL = Bundle.module.url(forResource: "v0", withExtension: "realm")!
         XCTAssertNoThrow(try Database(configuration: configuration))
         ```
         */
    }
}
