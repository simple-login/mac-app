//
//  KeychainServicing.swift
//
//
//  Created by Martin Lukacs on 19/11/2023.
//

import Foundation

public protocol KeychainServicing {
    @discardableResult
    func get<T: Decodable & Sendable>(key: String, ofType itemClassType: ItemClassType) async throws -> T
    func set<T: Encodable & Sendable>(_ item: T,
             for key: String,
             ofType itemClassType: ItemClassType,
             with access: KeychainAccessOptions,
             attributes: [CFString: any Sendable]?) async throws
    func delete(_ key: String, ofType itemClassType: ItemClassType) async throws
    func clear(ofType itemClassType: ItemClassType) async throws
}

extension KeychainServicing {
    @discardableResult
    func get<T: Decodable & Sendable>(key: String, ofType itemClassType: ItemClassType = .generic) async throws -> T {
       try await get(key: key, ofType: itemClassType)
    }

    func set<T: Encodable & Sendable>(_ item: T,
             for key: String,
             ofType itemClassType: ItemClassType = .generic,
             with access: KeychainAccessOptions = .default,
             attributes: [CFString: any Sendable]? = nil) async throws {
        try await set(item, for: key, ofType: itemClassType, with: access, attributes: attributes)
    }

    func delete(_ key: String, ofType itemClassType: ItemClassType = .generic) async throws {
        try await delete(key, ofType: itemClassType)
    }

    func clear(ofType itemClassType: ItemClassType = .generic) async throws {
        try await clear(ofType: itemClassType)
    }
}
