//
// MakeApiService.swift
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

public protocol MakeApiServiceUseCase: Sendable {
    func execute(apiUrl: ApiUrl, apiKey: ApiKey) throws -> APIServiceProtocol
}

public extension MakeApiServiceUseCase {
    func callAsFunction(apiUrl: ApiUrl, apiKey: ApiKey) throws -> APIServiceProtocol {
        try execute(apiUrl: apiUrl, apiKey: apiKey)
    }
}

public final class MakeApiService: MakeApiServiceUseCase {
    public init() {}

    public func execute(apiUrl: ApiUrl, apiKey: ApiKey) throws -> APIServiceProtocol {
        var printDebugInformation = false
        #if DEBUG
        printDebugInformation = true
        #endif
        guard let baseUrl = URL(string: apiUrl) else {
            throw SLError.badApiUrl(apiUrl)
        }
        return APIService(baseURL: baseUrl, 
                          session: .shared,
                          printDebugInformation: printDebugInformation)
    }
}
