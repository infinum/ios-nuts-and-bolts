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
}
