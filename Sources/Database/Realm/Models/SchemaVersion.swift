import Foundation
import RealmSwift
import OSLog

/// A list of Realm schema versions
/// Write a comment above each schema version
/// for easier lookup of what has changed
enum SchemaVersion: UInt64, CaseIterable {
    // Initial case
    case v0
    // Added property `x`
    case v1
    // Added property `id` on `User`
    case v2
}

extension SchemaVersion: Comparable {
    static func < (lhs: SchemaVersion, rhs: SchemaVersion) -> Bool { lhs.rawValue < rhs.rawValue }
}

extension SchemaVersion {
    /// Current schema version
    static var current: SchemaVersion { allCases.last! }
}

extension SchemaVersion {
    @available(iOS 14.0, *)
    static func execute(
        migration: Migration,
        from: SchemaVersion,
        to: SchemaVersion,
        migrations: [SchemaVersion: (Migration) -> Void] = Self.migrations
    ) {
        guard from < to else { return }
        for schema in SchemaVersion.allCases where schema > from && schema <= to {
            Logger.realm.log("Performing migration from \(from.rawValue) to \(to.rawValue)")
            migrations[schema]?(migration)
        }
    }
}

private extension SchemaVersion {
    /// A list of mappings from schema version to migration function
    /// Only add to this list if you need to perform custom migration
    /// If migration is automatically handled by Realm (e.g. adding a property)
    /// For more, see:
    /// https://www.mongodb.com/docs/realm/sdk/swift/model-data/change-an-object-model/#automatically-update-schema
    static var migrations: [SchemaVersion: (Migration) -> Void] {
        [
            .v1: migrateToV1
        ]
    }
}

private extension SchemaVersion {

    static func migrateToV1(migration: Migration) {
        /**
         Custom migration code.
         E.g.
         ```
         migration.enumerateObjects(ofType: "Test") { oldObject, newObject in
            newObject?["x"] = true
            newObject?["playing"] = oldObject?.migrationValue(of: Bool.self, from: "notPlaying").map { !$0 } ?? true
         }
         ```
         */
    }
}
