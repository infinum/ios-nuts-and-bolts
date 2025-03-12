//
//  UserDefault.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

@propertyWrapper
public final class UserDefault<Value> where Value: Codable {
    public let key: UserStorage.DefaultsKeys
    public let defaultValue: Value
    public let container: UserDefaults

    public init(_ key: UserStorage.DefaultsKeys, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = userDefaults
    }

    public var wrappedValue: Value {
        get { container.value(ofType: Value.self, forKey: key) ?? defaultValue }
        set { container.set(value: newValue, forKey: key) }
    }
}

// MARK: - Extensions

// MARK: - Convenince initializers

// MARK: Bool value

public extension UserDefault where Value == Bool {

    convenience init(_ key: UserStorage.DefaultsKeys) {
        self.init(key, defaultValue: false)
    }
}

// MARK: Int value

public extension UserDefault where Value == Int {

    convenience init(_ key: UserStorage.DefaultsKeys) {
        self.init(key, defaultValue: 0)
    }
}

// MARK: Nil value

public extension UserDefault where Value: ExpressibleByNilLiteral {

    convenience init(_ key: UserStorage.DefaultsKeys) {
        self.init(key, defaultValue: nil)
    }
}

// MARK: - Value getting & setting

private extension UserDefaults {

    func value<Value: Decodable>(
        ofType type: Value.Type,
        forKey key: UserStorage.DefaultsKeys,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Value? {
        let key = key.rawValue

        if let object = object(forKey: key) as? Value {
            return object
        }
        guard let data = data(forKey: key) else { return nil }

        return try? decoder.decode(Value.self, from: data)
    }

    func set<Value: Encodable>(value: Value, forKey key: UserStorage.DefaultsKeys, encoder: JSONEncoder = JSONEncoder()) {
        let key = key.rawValue

        if let optional = value as? AnyOptional, optional.isNil {
            set(nil, forKey: key)
            return
        }

        switch value {
        case let bool as Bool:
            set(bool, forKey: key)
        case let int as Int:
            set(int, forKey: key)
        case let string as String:
            set(string, forKey: key)
        case let url as URL:
            set(url, forKey: key)
        case let double as Double:
            set(double, forKey: key)
        case let float as Float:
            set(float, forKey: key)
        case let date as Date:
            set(date, forKey: key)
        default:
            let data = try? encoder.encode(value)
            set(data, forKey: key)
        }
    }
}
