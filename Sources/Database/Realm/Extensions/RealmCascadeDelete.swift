import RealmSwift
import Realm

/// Realm doesn't provide out of the box cascade delete.
/// It works for EmbeddedObjects, but we can't always use them.
/// This provides a generic way to cascade delete all child objects.
/// `ValidatedDelete` conformance allows fine grain control over deletion process.
/// For some discussion about this, see:
/// https://gist.github.com/krodak/b47ea81b3ae25ca2f10c27476bed450c
extension Realm {
    func cascadeDelete(_ object: EmbeddedObject) {
        let canDelete = (object as? ValidatedDelete)?.canBeRemovedFromRealm ?? true
        guard canDelete else { return }
        cascadeDelete(object, schema: object.objectSchema)
        delete(object)
    }

    func cascadeDelete(_ object: Object) {
        let canDelete = (object as? ValidatedDelete)?.canBeRemovedFromRealm ?? true
        guard canDelete else { return }
        cascadeDelete(object, schema: object.objectSchema)
        delete(object)
    }

    func cascadeDelete(_ objects: some Sequence<some Object>) {
        for obj in objects {
            cascadeDelete(obj)
        }
    }
}

private extension Realm {
    func cascadeDelete(_ object: NSObject, schema: ObjectSchema) {
        for property in schema.properties {
            guard let value = object.value(forKey: property.name) else { continue }
            if let child = value as? Object {
                // Unlink child from the parent.
                // Child's `LinkingObjects` will be properly reflected then.
                object.setValue(nil, forKey: property.name)
                cascadeDelete(child)
            }
            if let child = value as? EmbeddedObject {
                cascadeDelete(child)
            }
            if let list = (value as? RLMSwiftCollectionBase)?._rlmCollection {
                var listCopy = Set<Object>()
                for index in 0 ..< list.count {
                    guard let item = list.object(at: index) as? Object else { continue }
                    listCopy.insert(item)
                }
                // Unlink child from the parent.
                object.setValue(nil, forKey: property.name)
                for item in listCopy {
                    cascadeDelete(item)
                }
            }
        }
    }
}
