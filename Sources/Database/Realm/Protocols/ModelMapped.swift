import Foundation
import RealmSwift

/// It is generally useful to associate domain object with DB object
/// Realm objects that conform to this protocol can define mappings
/// to and from domain object
@available(iOS 13.0, *)
protocol ModelMapped<Model>: Object {
    associatedtype Model: Identifiable
    func update(with model: Model, realm: Realm?)
    var asModel: Model { get }
}

@available(iOS 13.0, *)
extension ModelMapped {
    init(model: Model, realm: Realm?) {
        self.init()
        update(with: model, realm: realm)
        realm?.add(self)
    }
}
