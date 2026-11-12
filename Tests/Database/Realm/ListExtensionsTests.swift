import XCTest
import RealmSwift
@testable import Catalog

@available(iOS 14.0, *)
final class ListExtensionsTests: XCTestCase {

    func testCreateRealmListFromArray() {
        let list = List([UserDB(), UserDB(), UserDB()])
        XCTAssertEqual(list.count, 3)
    }

    func testRemoveFromRealmList() {
        let items = [UserDB(), UserDB(), UserDB()]
        let list = List(items)

        let toRemove = items.first!
        list.remove(items: [toRemove])
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.count, 2)
        XCTAssertFalse(list.contains(toRemove))
    }
}
