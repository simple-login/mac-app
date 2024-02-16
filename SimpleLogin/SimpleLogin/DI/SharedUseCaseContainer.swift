//
// SharedUseCaseContainer.swift
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

import Factory
import Foundation
import Shared

final class SharedUseCaseContainer: SharedContainer, AutoRegistering {
    static let shared = SharedUseCaseContainer()
    let manager = ContainerManager()

    func autoRegister() {
        manager.defaultScope = .shared
    }
}

private extension SharedUseCaseContainer {
    var keychain: KeychainProvider {
        SharedToolingContainer.shared.keychain()
    }
}

extension SharedUseCaseContainer {
    var logEnabled: Factory<LogEnabledUseCase> {
        self { LogEnabled() }
    }

    var createLogger: Factory<CreateLoggerUseCase> {
        self { CreateLogger() }
            .unique
    }

    var getSafariExtensionState: Factory<GetSafariExtensionStateUseCase> {
        self { GetSafariExtensionState() }
    }

    var processSafariExtensionEvent: Factory<ProcessSafariExtensionEventUseCase> {
        self { ProcessSafariExtensionEvent(createLogger: self.createLogger(),
                                           logEnabled: self.logEnabled()) }
    }

    var getApiUrl: Factory<GetApiUrlUseCase> {
        self { GetApiUrl(keychain: self.keychain) }
    }

    var setApiUrl: Factory<SetApiUrlUseCase> {
        self { SetApiUrl(keychain: self.keychain) }
    }

    var getApiKey: Factory<GetApiKeyUseCase> {
        self { GetApiKey(keychain: self.keychain) }
    }

    var setApiKey: Factory<SetApiKeyUseCase> {
        self { SetApiKey(keychain: self.keychain) }
    }

    var apiServiceProvider: Factory<ApiServiceProviderUseCase> {
        self { ApiServiceProvider(logEnabled: self.logEnabled()) }
    }

    var getUserInfo: Factory<GetUserInfoUseCase> {
        self { GetUserInfo(apiServiceProvider: self.apiServiceProvider(),
                           getApiUrl: self.getApiUrl(),
                           getApiKey: self.getApiKey()) }
    }

    var getStats: Factory<GetStatsUseCase> {
        self { GetStats(apiServiceProvider: self.apiServiceProvider(),
                        getApiUrl: self.getApiUrl(),
                        getApiKey: self.getApiKey()) }
    }

    var getSubscriptions: Factory<GetSubscriptionsUseCase> {
        self { GetSubscriptions() }
    }

    var purchaseProduct: Factory<PurchaseProductUseCase> {
        self { PurchaseProduct() }
    }

    var fetchAndSendReceipt: Factory<FetchAndSendReceiptUseCase> {
        self { FetchAndSendReceipt(apiServiceProvider: self.apiServiceProvider(),
                                   getApiUrl: self.getApiUrl(),
                                   getApiKey: self.getApiKey()) }
    }
}
