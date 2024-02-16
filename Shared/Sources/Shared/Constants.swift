//
// Constants.swift
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

public let kSharedUserDefaults = UserDefaults(suiteName: Constants.appGroup)

public enum Constants {
    public static let teamId = "2SB5Z68H26"
    public static let bundleId = "me.proton.simplelogin.macos"
    public static let extensionBundleId = "me.proton.simplelogin.macos.safari-extension"
    public static let appGroup = "group.me.proton.simplelogin.macos"
    public static let keychainAccessGroup = "\(teamId).\(appGroup)"
    public static let defaultApiUrl: ApiUrl = "https://app.simplelogin.io"
    public static let apiUrlKey = "API_URL"
    public static let apiKeyKey = "API_KEY"
    public static let logEnabledKey = "LOG_ENABLED"
}

public typealias ApiUrl = String
public typealias ApiKey = String
