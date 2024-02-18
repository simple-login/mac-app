//
// FetchAndSendReceipt.swift
// SimpleLogin - Created on 06/02/2024.
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
@preconcurrency import OSLog
import SimpleLoginPackage
import StoreKit

public protocol FetchAndSendReceiptUseCase: Sendable {
    func execute() async throws -> Bool
}

public extension FetchAndSendReceiptUseCase {
    @discardableResult
    func callAsFunction() async throws -> Bool {
        try await execute()
    }
}

public final class FetchAndSendReceipt: FetchAndSendReceiptUseCase {
    private let apiServiceProvider: any ApiServiceProviderUseCase
    private let getApiUrl: any GetApiUrlUseCase
    private let getApiKey: any GetApiKeyUseCase
    private let logger: Logger
    private let logEnabled: any LogEnabledUseCase

    public init(apiServiceProvider: any ApiServiceProviderUseCase,
                getApiUrl: any GetApiUrlUseCase,
                getApiKey: any GetApiKeyUseCase,
                createLogger: any CreateLoggerUseCase,
                logEnabled: any LogEnabledUseCase) {
        self.apiServiceProvider = apiServiceProvider
        self.getApiUrl = getApiUrl
        self.getApiKey = getApiKey
        logger = createLogger(category: String(describing: Self.self))
        self.logEnabled = logEnabled
    }

    public func execute() async throws -> Bool {
        let apiUrl = try await getApiUrl()
        guard let apiKey = try await getApiKey() else {
            throw SLError.noApiKey
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            throw SLError.missingAppStoreReceiptURL
        }

        let logEnabled = logEnabled()

        if logEnabled {
            logger.publicDebug("Found receipt URL \(appStoreReceiptUrl.absoluteString)")
        }

        let receiptData = try Data(contentsOf: appStoreReceiptUrl)
        let receiptDataBase64 = receiptData.base64EncodedString()

        if logEnabled {
            logger.publicDebug("Sending receipt data \(receiptDataBase64)")
        }

        let endpoint = ProcessPaymentEndpoint(apiKey: apiKey,
                                              receiptData: receiptDataBase64,
                                              isMacApp: true)
        let apiService = try apiServiceProvider(apiUrl: apiUrl)
        let result = try await apiService.execute(endpoint)
        if logEnabled {
            logger.publicInfo("Sent receipt data \(receiptDataBase64)")
        }
        return result.value
    }
}
