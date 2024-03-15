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
    func execute() async throws -> Stats
}

public extension GetStatsUseCase {
    func callAsFunction() async throws -> Stats {
        try await execute()
    }
}

public final class GetStats: GetStatsUseCase {
    private let apiServiceProvider: any ApiServiceProviderUseCase
    private let getApiUrl: any GetApiUrlUseCase
    private let getApiKey: any GetApiKeyUseCase

    public init(apiServiceProvider: any ApiServiceProviderUseCase,
                getApiUrl: any GetApiUrlUseCase,
                getApiKey: any GetApiKeyUseCase) {
        self.apiServiceProvider = apiServiceProvider
        self.getApiUrl = getApiUrl
        self.getApiKey = getApiKey
    }

    public func execute() async throws -> Stats {
        let apiUrl = try await getApiUrl()
        guard let apiKey = try await getApiKey() else {
            throw SLError.noApiKey
        }
        let apiService = try apiServiceProvider(apiUrl: apiUrl)
        let endpoint = GetStatsEndpoint(apiKey: apiKey)
        return try await apiService.execute(endpoint)
    }
}
