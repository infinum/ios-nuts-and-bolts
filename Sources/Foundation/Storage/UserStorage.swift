//
//  UserStorage.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

/// A protocol that defines all of the values or objects that should be stored in the `UserDefaults`
public protocol DefaultsStorageInterface: AnyObject {
    // Example value
    var username: String? { get set }
    var gameTag: String? { get set }
}

/// A protocol that defines all of the values or objects that should be stored in memory.
/// - Note: Since we're keeping things in memory, objects will be released at some point, hence being optional. This can occur on app restart or during runtime depending on the case.
public protocol MemoryStorageInterface: AnyObject {
    var lastName: String? { get set }
}

typealias UserStorageInterface = DefaultsStorageInterface & MemoryStorageInterface

public final class UserStorage: UserStorageInterface {

    // MARK: - Singleton -

    static let instance: UserStorageInterface = UserStorage()
    private init() { }

    private let memoryStorage = MemoryStorage()

    // MARK: - Properties -

    // MARK: - User defaults storage

    @UserDefault(.username)
    public var username: String?

    @Keychain(.gameTag)
    public var gameTag: String?

    // MARK: - Memory storage

    public var lastName: String? {
        get { memoryStorage.lastName }
        set { memoryStorage.lastName = newValue }
    }
}

// MARK: - Extensions -

// MARK: - Keys

public extension UserStorage {

    enum DefaultsKeys: String, CaseIterable {
        case username

        // Test cases

        case nonOptionalBoolValue
        case nonOptionalBoolDefaultValue
        case optionalBoolValue
        case nonOptionalIntValue
        case nonOptionalDefaultIntValue
        case optionalIntValue
        case nonOptionalFloatValue
        case nonOptionalDefaultFloatValue
        case optionalFloatValue
        case nonOptionalDoubleValue
        case nonOptionalDefaultDoubleValue
        case optionalDoubleValue
        case nonOptionalStringValue
        case nonOptionalDefaultStringValue
        case optionalStringValue
        case nonOptionalCodableValue
        case nonOptionalDefaultCodableValue
        case optionalCodableValue
        case nonOptionalEnumValue
        case nonOptionalEnumDefaultValue
        case optionalCodableValueCustomUserDefaults
        case nonOptionalStringValueCustomUserDefaults
        case nonOptionalEnumValueCustomUserDefaults
    }

    enum KeychainKeys: String, CaseIterable {
        case gameTag

        // Test cases
        case nonOptionalStringDefaultValue
        case optionalStringValue
    }
}

// MARK: - Memory storage -

private final class MemoryStorage: MemoryStorageInterface {
    var lastName: String?
}
