// The Swift Programming Language
// https://docs.swift.org/swift-book

import Security
import Foundation

public actor SimpleKeychain: KeychainServicing {
    private let service: String?
    private let accessGroup: String?

    public init( service: String? = nil, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    @discardableResult
    public func get<T: Decodable & Sendable>(key: String, ofType itemClassType: ItemClassType = .generic) throws -> T {
        var query = createQuery(for: key, ofType: itemClassType)
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue

        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        if result != errSecSuccess {
            throw result.toSimpleKeychainError
        }

        guard let keychainItem = item as? [CFString: Any],
              let data = keychainItem[kSecValueData] as? Data else {
            throw SimpleKeychainError.invalidData
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    public func set<T: Encodable & Sendable>(_ item: T,
                                             for key: String,
                                             ofType itemClassType: ItemClassType = .generic,
                                             with access: KeychainAccessOptions = .default,
                                             attributes: [CFString: any Sendable]? = nil) throws {
        let data = try JSONEncoder().encode(item)

        do {
            try add(with: data, key: key, ofType: itemClassType, with: access, attributes: attributes)
        } catch SimpleKeychainError.duplicateItem {
            try update(with: data, key: key, ofType: itemClassType, with: access, attributes: attributes)
        }
    }

    public func delete(_ key: String, ofType itemClassType: ItemClassType = .generic) throws {
        let query = createQuery(for: key, ofType: itemClassType)

        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess {
            throw result.toSimpleKeychainError
        }
    }

    public func clear(ofType itemClassType: ItemClassType = .generic) throws {
        var query: [CFString: Any] = [kSecClass: itemClassType.rawValue ]
        if let accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }

        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess {
            throw result.toSimpleKeychainError
        }
    }
}

private extension SimpleKeychain {

    func update(with data: Data,
                key: String,
                ofType itemClassType: ItemClassType,
                with access: KeychainAccessOptions,
                attributes: [CFString: Any]? = nil) throws {
        let query = createQuery(for: key, ofType: itemClassType, access: access, attributes: attributes)
        let updates: [CFString: Any] = [
            kSecValueData: data
        ]

        let result = SecItemUpdate(query as CFDictionary, updates as CFDictionary)
        if result != errSecSuccess {
            throw result.toSimpleKeychainError
        }
    }

    func add(with data: Data,
             key: String,
             ofType itemClassType: ItemClassType,
             with access: KeychainAccessOptions,
             attributes: [CFString: Any]? = nil) throws {
        let query = createQuery(for: key, ofType: itemClassType, with: data, access: access, attributes: attributes)

        let result = SecItemAdd(query as CFDictionary, nil)
        if result != errSecSuccess {
            throw result.toSimpleKeychainError
        }
    }

    func createQuery(for key: String,
                     ofType itemClassType: ItemClassType,
                     with data: Data? = nil,
                     access: KeychainAccessOptions = .default,
                     attributes: [CFString: Any]? = nil) -> [CFString: Any] {
        var query: [CFString: Any] = [:]
        query[kSecClass] = itemClassType.rawValue
        query[kSecAttrAccount] = key
        query[kSecAttrAccessible] = access.value
        query[kSecUseDataProtectionKeychain] = kCFBooleanTrue

        if let data {
            query[kSecValueData] = data
        }

        if let service {
            query[kSecAttrService] = service
        }

        if let accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }

        if let attributes {
            for(key, value) in attributes {
                query[key] = value
            }
        }

        return query
    }
}

