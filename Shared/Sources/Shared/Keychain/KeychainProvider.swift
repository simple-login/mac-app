//
// KeychainProvider.swift
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
import os.object
import KeychainAccess

public protocol KeychainProvider: Sendable {
    func getValueFromKeychain(for key: String) -> String?
    func setValueToKeychain(_ value: String?, for key: String)
}

extension Keychain: KeychainProvider {
    public func getValueFromKeychain(for key: String) -> String? {
        os_log(.default, "[SimpleLogin] Get value for key %{public}@", key)
        return self[key]
    }
    
    public func setValueToKeychain(_ value: String?, for key: String) {
        os_log(.default, "[SimpleLogin] Set value %{public}@ for key %{public}@", value ?? "", key)
        self[key] = value
    }
}
