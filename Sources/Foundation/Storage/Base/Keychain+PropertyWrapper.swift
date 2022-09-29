//
//  Keychain+PropertyWrapper.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Security

@propertyWrapper
final class Keychain<T> where T: Codable {
    let key: UserStorage.KeychainKeys
    let defaultValue: T

    init(_ key: UserStorage.KeychainKeys, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get { value(forKey: key) ?? defaultValue }
        set { set(value: newValue, forKey: key) }
    }
}

extension Keychain where T: ExpressibleByNilLiteral {

    convenience init(_ key: UserStorage.KeychainKeys) {
        self.init(key, defaultValue: nil)
    }
}

extension Keychain {

    func set(value: T, forKey key: UserStorage.KeychainKeys) {

        if let optional = value as? AnyOptional, optional.isNil {
            remove(valueForKey: key)
            return
        }

        guard let data = try? JSONEncoder().encode(value) else { return }

        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrAccount)] = key.rawValue

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            let attributesToUpdate: [String: Any] = [
                String(kSecValueData): data
            ]
            SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        case errSecItemNotFound:
            query[String(kSecValueData)] = data
            SecItemAdd(query as CFDictionary, nil)
        default:
            return
        }
    }

    func value(forKey key: UserStorage.KeychainKeys) -> T? {
        var query: [String: Any] = [:]
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrAccount)] = key.rawValue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any], let data = queriedItem[String(kSecValueData)] as? Data
            else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        default:
            return nil
        }
    }

    func remove(valueForKey key: UserStorage.KeychainKeys) {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrAccount)] = key.rawValue

        SecItemDelete(query as CFDictionary)
    }
}
