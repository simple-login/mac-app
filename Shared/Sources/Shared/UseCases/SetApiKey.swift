//
// SetApiKey.swift
// SimpleLogin - Created on 10/01/2024.
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

public protocol SetApiKeyUseCase: Sendable {
    func execute(_ apiKey: String?)
}

public extension SetApiKeyUseCase {
    func callAsFunction(_ apiKey: String?) {
        execute(apiKey)
    }
}

public final class SetApiKey: SetApiKeyUseCase {
    private let keychain: KeychainProvider

    public init(keychain: KeychainProvider) {
        self.keychain = keychain
    }

    public func execute(_ apiKey: String?) {
        keychain.setValueToKeychain(apiKey, for: Constants.apiKeyKey)
    }
}
