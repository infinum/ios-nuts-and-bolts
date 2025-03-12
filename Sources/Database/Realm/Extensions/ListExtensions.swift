import RealmSwift

extension List {
    convenience init(_ sequence: some Sequence<Element>) {
        self.init()
        append(objectsIn: sequence)
    }

    func remove(items: some Sequence<Element>) {
        for item in items {
            if let index = firstIndex(of: item) {
                remove(at: index)
            }
        }
    }
}
