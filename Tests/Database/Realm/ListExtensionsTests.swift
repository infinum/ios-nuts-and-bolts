import XCTest
import RealmSwift
@testable import Catalog

@available(iOS 14.0, *)
final class ListExtensionsTests: XCTestCase {

    func testCreateRealmListFromArray() {
        let list = List([User(), User(), User()])
        XCTAssertEqual(list.count, 3)
    }

    func testRemoveFromRealmList() {
        let items = [User(), User(), User()]
        let list = List(items)

        let toRemove = items.first!
        list.remove(items: [toRemove])
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.count, 2)
        XCTAssertFalse(list.contains(toRemove))
    }
}
