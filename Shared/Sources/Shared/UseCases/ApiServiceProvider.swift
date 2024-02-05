//
// ApiServiceProvider.swift
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

public protocol ApiServiceProviderUseCase: Sendable {
    func execute(apiUrl: ApiUrl) throws -> APIServiceProtocol
}

public extension ApiServiceProviderUseCase {
    func callAsFunction(apiUrl: ApiUrl) throws -> APIServiceProtocol {
        try execute(apiUrl: apiUrl)
    }
}

public final class ApiServiceProvider: ApiServiceProviderUseCase {
    private let printDebugInformation: Bool

    public init(printDebugInformation: Bool) {
        self.printDebugInformation = printDebugInformation
    }

    public func execute(apiUrl: ApiUrl) throws -> APIServiceProtocol {
        guard let baseUrl = URL(string: apiUrl) else {
            throw SLError.badApiUrl(apiUrl)
        }
        return APIService(baseURL: baseUrl,
                          session: .shared,
                          printDebugInformation: printDebugInformation)
    }
}
