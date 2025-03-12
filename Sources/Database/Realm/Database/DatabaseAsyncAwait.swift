import Foundation
import RealmSwift

@available(iOS 14.0, *)
extension Database {
    func read<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        id: String
    ) async throws -> DBModel.Model {
        try await realm.read(dbModel: DBModel.self, id: id, mapping: \.asModel)
    }

    func readOptional<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        id: String
    ) async throws -> DBModel.Model? {
        try await realm.readOptional(dbModel: DBModel.self, id: id, mapping: \.asModel)
    }

    func update<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        with model: DBModel.Model
    ) async throws {
        try await realm.update(type, id: model.id) { [realm = realm!] in
            $0.update(with: model, realm: realm)
        }
    }

    func createOrUpdate<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        with model: DBModel.Model
    ) async throws {
        try await realm.createOrUpdate(type, id: model.id) { [realm = realm!] in
            $0.update(with: model, realm: realm)
        }
    }
}
