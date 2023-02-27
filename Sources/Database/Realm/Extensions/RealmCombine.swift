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
}
