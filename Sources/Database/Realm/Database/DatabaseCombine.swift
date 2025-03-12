import Foundation
import Combine
import RealmSwift

@available(iOS 14.0, *)
extension Database {
    /// Create realm object from domain object
    /// See also: `createOrUpdate`
    func create<DBModel>(
        _ type: DBModel.Type,
        model: DBModel.Model
    ) -> Future<Void, Error> where DBModel: ModelMapped {
        realm.create { realm in DBModel(model: model, realm: realm) }
    }

    /// Find a realm object by id and return domain object
    /// In case when object doesn't exist, this will complete with error
    func read<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        id: String
    ) -> Future<DBModel.Model, Error> {
        realm.read(dbModel: DBModel.self, id: id, mapping: \.asModel)
    }

    /// Observe changes of object with id
    /// This will observe all changes on a realm object
    /// and publish mapped domain objects
    func observe<DBModel: Object, Model>(
        dbModel type: DBModel.Type,
        id: String,
        mapping: @escaping (DBModel) -> Model
    ) -> some Publisher<Model, Never> {
        realm.read(dbModel: type, id: id)
            .receive(on: DispatchQueue.database)
            .flatMap { object in
                valuePublisher(object)
                    .prepend(object)
                    .map(mapping)
            }
            .assertNoFailure()
    }

    /// Observe changes of object with id
    /// This will observe changes on a realm object at key path
    /// and publish mapped domain objects
    func observe<DBModel: Object, Model, Value>(
        dbModel type: DBModel.Type,
        id: String,
        keyPath: KeyPath<DBModel, Value>,
        mapping: @escaping (Value) -> Model
    ) -> some Publisher<Model, Never> {
        realm.read(dbModel: type, id: id, mapping: { $0 })
            .receive(on: DispatchQueue.database)
            .flatMap { object in
                valuePublisher(object, keyPaths: [_name(for: keyPath)])
                    .prepend(object)
                    .map { mapping($0[keyPath: keyPath]) }
            }
            .assertNoFailure()
    }

    func update<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        with model: DBModel.Model
    ) -> ThrowingTaskPublisher<Void> {
        realm.update(DBModel.self, id: model.id) { [realm = realm!] object in object.update(with: model, realm: realm) }
    }

    func createOrUpdate<DBModel: ModelMapped>(
        _ type: DBModel.Type,
        with model: DBModel.Model
    ) -> ThrowingTaskPublisher<Void> {
        realm.createOrUpdate(DBModel.self, id: model.id) { [realm = realm!] object in object.update(with: model, realm: realm) }
    }
}
