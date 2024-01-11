//
// GetUserInfo.swift
// SimpleLogin - Created on 11/01/2024.
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
import SimpleLoginPackage

public protocol GetUserInfoUseCase: Sendable {
    func execute(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> UserInfo
}

public extension GetUserInfoUseCase {
    func callAsFunction(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> UserInfo {
        try await execute(apiUrl: apiUrl, apiKey: apiKey)
    }
}

public final class GetUserInfo: GetUserInfoUseCase {
    private let makeApiService: MakeApiServiceUseCase

    public init(makeApiService: MakeApiServiceUseCase) {
        self.makeApiService = makeApiService
    }

    public func execute(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> UserInfo {
        let apiService = try makeApiService(apiUrl: apiUrl)
        let endpoint = GetUserInfoEndpoint(apiKey: apiKey)
        return try await apiService.execute(endpoint)
    }
}
