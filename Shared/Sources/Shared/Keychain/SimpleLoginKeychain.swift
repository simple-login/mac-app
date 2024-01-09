//
// SimpleLoginKeychain.swift
// SimpleLogin - Created on 09/01/2024.
// Copyright (c) 2024 Proton Technologies AG
//
// This file is part of SimpleLogin.
//
// SimpleLogin is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// SimpleLogin is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SimpleLogin. If not, see https://www.gnu.org/licenses/.
//

import Foundation

public protocol SimpleLoginKeychainProtocol {
    func getApiUrl() -> String
    func setApiUrl(_ apiUrl: String)
    func getApiKey() -> String?
    func setApiKey(_ apiKey: String?)
}

public final class SimpleLoginKeychain: SimpleLoginKeychainProtocol {
    private let keychain: KeychainProvider

    public init(keychain: KeychainProvider) {
        self.keychain = keychain
    }
}

public extension SimpleLoginKeychain {
    func getApiUrl() -> String {
        keychain.getValueFromKeychain(for: Constants.apiUrlKey) ?? Constants.defaultApiUrl
    }

    func setApiUrl(_ apiUrl: String) {
        keychain.setValueToKeychain(apiUrl, for: Constants.apiUrlKey)
    }

    func getApiKey() -> String? {
        keychain.getValueFromKeychain(for: Constants.apiKeyKey)
    }

    func setApiKey(_ apiKey: String?) {
        keychain.setValueToKeychain(apiKey, for: Constants.apiKeyKey)
    }
}
