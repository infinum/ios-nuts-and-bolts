import Foundation
import RealmSwift
import Realm
import OSLog

class Database {
    private(set) var realm: Realm!

    init(configuration: Realm.Configuration? = nil) throws {
        let config = try configuration ?? Database.defaultConfiguration()
        if let fileURL = config.fileURL {
            if #available(iOS 14.0, *) {
                Logger.realm.debug("Database URL: \(fileURL)")
            }
        }
        try DispatchQueue.database.sync { [unowned self] in
            realm = try Realm(configuration: config, queue: DispatchQueue.database)
        }
    }
}

extension Database {
    /// Default realm configuration
    /// Takes care of migrations, seeds and compacting if needed
    static func defaultConfiguration() throws -> Realm.Configuration {
        return Realm.Configuration(
            fileURL: try Self.defaultURL(),
            schemaVersion: SchemaVersion.current.rawValue,
            migrationBlock: { migration, oldVersion in
                SchemaVersion.execute(
                    migration: migration,
                    from: SchemaVersion(rawValue: oldVersion)!,
                    to: .current
                )
            },
            deleteRealmIfMigrationNeeded: false,
            shouldCompactOnLaunch: { _, _ in false },
            seedFilePath: try seedURL
        )
    }

    static func defaultURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("database.realm")
    }

    /// Specify a path to `seedURL` in your bundle.
    /// Use seed database only if you really need it.
    static var seedURL: URL? {
        get throws {
            if FileManager.default.fileExists(atPath: try defaultURL().path) { return nil }
            return nil
        }
    }
}
