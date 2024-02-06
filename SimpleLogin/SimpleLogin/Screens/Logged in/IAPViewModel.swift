//
// IAPViewModel.swift
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

import Factory
import Foundation
import Shared
import StoreKit

enum UpgradeState {
    case idle
    case upgrading
    case upgraded
    case error(Error)

    var error: Error? {
        if case let .error(error) = self {
            return error
        }
        return nil
    }
}

@MainActor
final class IAPViewModelModel: ObservableObject {
    @Published private(set) var upgradeState: UpgradeState = .idle
    let subscriptions: Subscriptions

    private var lastProduct: Product?
    private let purchaseProduct = resolve(\SharedUseCaseContainer.purchaseProduct)
    private let fetchAndSendReceipt = resolve(\SharedUseCaseContainer.fetchAndSendReceipt)

    init(subscriptions: Subscriptions) {
        self.subscriptions = subscriptions
    }

    func subscribeYearly() {
        buy(product: subscriptions.yearly)
    }

    func subscribeMonthly() {
        buy(product: subscriptions.monthly)
    }

    func retry() {
        if let lastProduct {
            buy(product: lastProduct)
        }
    }
}

private extension IAPViewModelModel {
    func buy(product: Product) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            lastProduct = product
            do {
                upgradeState = .upgrading
                try await purchaseProduct(product)
                try await fetchAndSendReceipt()
                upgradeState = .upgraded
            } catch {
                upgradeState = .error(error)
            }
        }
    }
}

extension UpgradeState: Equatable {
    static func == (lhs: UpgradeState, rhs: UpgradeState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.upgrading, .upgrading),
            (.upgraded, .upgraded):
            return true
        case let (.error(lError), .error(rError)):
            return lError.localizedDescription == rError.localizedDescription
        default:
            return false
        }
    }
}
