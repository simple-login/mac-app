//
// GetStats.swift
// SimpleLogin - Created on 05/02/2024.
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

public protocol GetStatsUseCase: Sendable {
    func execute(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> Stats
}

public extension GetStatsUseCase {
    func callAsFunction(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> Stats {
        try await execute(apiUrl: apiUrl, apiKey: apiKey)
    }
}

public final class GetStats: GetStatsUseCase {
    private let apiServiceProvider: ApiServiceProviderUseCase

    public init(apiServiceProvider: ApiServiceProviderUseCase) {
        self.apiServiceProvider = apiServiceProvider
    }

    public func execute(apiUrl: ApiUrl, apiKey: ApiKey) async throws -> Stats {
        let apiService = try apiServiceProvider(apiUrl: apiUrl)
        let endpoint = GetStatsEndpoint(apiKey: apiKey)
        return try await apiService.execute(endpoint)
    }
}
