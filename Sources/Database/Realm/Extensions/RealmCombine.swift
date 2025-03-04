import RealmSwift
import Combine

@available(iOS 13.0, *)
extension Realm {
    func read<DBModel: Object, Model>(
        dbModel type: DBModel.Type,
        id: String,
        mapping: @escaping (DBModel) -> Model
    ) -> Future<Model, Swift.Error> {
        DispatchQueue.database.asyncFuture { promise in
            promise(.init(catching: { try mapping(findObject(of: type, for: id)) }))
        }
    }

    func read<DBModel: Object>(
        dbModel type: DBModel.Type,
        id: String
    ) -> Future<DBModel, Swift.Error> {
        read(dbModel: DBModel.self, id: id, mapping: { $0 })
    }

    func create<DBModel: Object>(
        _ createBlock: @escaping (Realm) -> DBModel
    ) -> Future<Void, Swift.Error> {
        return DispatchQueue.database.asyncFuture { promise in
            do {
                try write {
                    let object = createBlock(self)
                    add(object)
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func update<DBModel: Object, KeyType>(
        _ type: DBModel.Type,
        id: KeyType,
        update: @escaping (DBModel) -> Void
    ) -> ThrowingTaskPublisher<Void> {
        ThrowingTaskPublisher { try await self.update(type, id: id, update: update) }
    }

    func createOrUpdate<DBModel: Object, KeyType>(
        _ type: DBModel.Type,
        id: KeyType,
        update: @escaping (DBModel) -> Void
    ) -> ThrowingTaskPublisher<Void> {
        ThrowingTaskPublisher { try await createOrUpdate(type, id: id, update: update) }
    }
}
