import Foundation

/// Allow an object to decide if it should be deleted from the realm.
/// Useful in cases when something else has a reference to the object.
/// This can elegantly be implemented by using `LinkingObject`.
/// See: https://www.mongodb.com/docs/realm-sdks/swift/latest/Structs/LinkingObjects.html
protocol ValidatedDelete {
    var canBeRemovedFromRealm: Bool { get }
}

extension ValidatedDelete {
    var canBeRemovedFromRealm: Bool { true }
}
