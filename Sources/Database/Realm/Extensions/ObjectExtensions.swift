import RealmSwift

extension Object {
    /// It is not allowed to update primary key once
    /// an object is already inserted
    /// This helper function allows us to easily query that
    var isInserted: Bool { realm != nil }

    func updateIfNotInserted(_ update: () -> Void) {
        if !isInserted { update() }
    }
}
