import RealmSwift

extension MigrationObject {
    /// Optionally fetches a property if target schema contains it
    /// Useful to write a migration code resilient to adding/removing properties
    func migrationValue<T>(of type: T.Type, from key: String) -> T? {
        guard objectSchema.properties.contains(where: { $0.name == key }) else { return nil }
        return self[key] as? T
    }
}
