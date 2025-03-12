import RealmSwift

extension Realm {
    func deleteIfPresent(_ object: some Object) {
        guard object.realm == self else { return }
        delete(object)
    }

    func deleteIfPresent(_ objects: some Sequence<Object>) {
        objects.forEach(deleteIfPresent)
    }

    func findObject<T: Object, KeyType>(
        of type: T.Type,
        for id: KeyType
    ) throws -> T {
        guard let object = object(ofType: T.self, forPrimaryKey: id) else {
            throw NotFoundError(type: T.className(), id: id)
        }
        return object
    }

    func findOrCreateObject<DBModel: Object, KeyType>(
        _ type: DBModel.Type,
        id: KeyType,
        update: @escaping (DBModel) -> Void
    ) {
        if let object = object(ofType: type, forPrimaryKey: id) {
            update(object)
            return
        }
        let object = DBModel()
        update(object)
        add(object)
    }
}

@available(iOS 13.0, *)
extension Realm {

    @discardableResult
    func execute<T>(_ block: @escaping (Realm) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Swift.Error>) in
            DispatchQueue.database.async {
                do {
                    let response = try block(self)
                    continuation.resume(with: .success(response))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }

    @discardableResult
    func executeWrite<T>(_ block: @escaping (Realm) throws -> T) async throws -> T {
        try await execute { realm in
            try realm.write { try block(self) }
        }
    }

    func fetch<T>(read: @escaping (Realm) throws -> T) async throws -> T {
        try await execute(read)
    }
}

@available(iOS 13.0, *)
extension Realm {
    func read<DBModel: Object, Model>(
        dbModel type: DBModel.Type,
        id: String,
        mapping: @escaping (DBModel) -> Model
    ) async throws -> Model {
        try await fetch { _ in
            try mapping(findObject(of: type, for: id))
        }
    }

    func readOptional<DBModel: Object, Model>(
        dbModel type: DBModel.Type,
        id: String,
        mapping: @escaping (DBModel) -> Model
    ) async throws -> Model? {
        try await fetch { _ in
            guard let object = object(ofType: type, forPrimaryKey: id) else { return nil }
            return mapping(object)
        }
    }

    func update<DBModel: Object, KeyType>(
        _ type: DBModel.Type,
        id: KeyType,
        update: @escaping (DBModel) -> Void
    ) async throws {
        try await executeWrite { _ in
            let object = try findObject(of: type, for: id)
            update(object)
        }
    }

    func createOrUpdate<DBModel: Object, KeyType>(
        _ type: DBModel.Type,
        id: KeyType,
        update: @escaping (DBModel) -> Void
    ) async throws {
        try await executeWrite { _ in findOrCreateObject(type, id: id, update: update) }
    }
}
