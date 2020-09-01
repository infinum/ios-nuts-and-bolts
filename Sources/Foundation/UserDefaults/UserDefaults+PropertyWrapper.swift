//
//  UserDefaults+PropertyWrapper.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 01/09/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation

@propertyWrapper
struct Storage<Value, StoredValue> {

    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults
    private let get: (StoredValue) -> Value
    private let set: (Value) -> StoredValue

    private init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = UserDefaults.standard, get: @escaping (StoredValue) -> Value, set: @escaping (Value) -> StoredValue) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.get = get
        self.set = set
    }

    public var wrappedValue: Value {
        get {
            if let stored = userDefaults.object(forKey: key) as? StoredValue {
                return get(stored)
            }
            return defaultValue
        }
        set (newValue) {
            let toStore = set(newValue)
            switch toStore as Any {
                case Swift.Optional<Any>.none:
                    userDefaults.removeObject(forKey: key)
                // swiftlint:disable:next syntactic_sugar
                case Swift.Optional<Any>.some(let value):
                    userDefaults.set(value, forKey: key)
                default:
                    userDefaults.set(toStore, forKey: key)
            }
        }
    }
}

extension Storage where Value: RawRepresentable, Value.RawValue == StoredValue {

    init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.init(
            key,
            defaultValue: defaultValue,
            get: { return Value.init(rawValue: $0) ?? defaultValue },
            set: { return $0.rawValue }
        )
    }
}

extension Storage where Value == StoredValue {

    init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.init(
            key,
            defaultValue: defaultValue,
            get: { $0 },
            set: { $0 }
        )
    }

    init<T>(_ key: String, userDefaults: UserDefaults = .standard) where Value == T? {
        self.init(
            key,
            defaultValue: nil,
            userDefaults: userDefaults,
            get: { $0 },
            set: { $0 }
        )
    }
}

extension Storage where Value: Codable, StoredValue == Data? {

    init(codable key: String, defaultValue: Value, userDefaults: UserDefaults = .standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.init(
            key,
            defaultValue: defaultValue,
            get: {
                guard let storedData = $0 else {
                    return defaultValue
                }
                return (try? decoder.decode(Value.self, from: storedData)) ?? defaultValue
        },
            set: { return try? encoder.encode($0) }
        )
    }

    init<T>(codable key: String, userDefaults: UserDefaults = .standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) where Value == T? {
        self.init(
            key,
            defaultValue: nil,
            userDefaults: userDefaults,
            get: {
                guard let storedData = $0 else { return nil }
                return try? decoder.decode(Value.self, from: storedData)
        },
            set: { return try? encoder.encode($0) }
        )
    }

}
