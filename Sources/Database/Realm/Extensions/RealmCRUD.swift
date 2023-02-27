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
