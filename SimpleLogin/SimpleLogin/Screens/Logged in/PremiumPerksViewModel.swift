//
// PremiumPerksViewModel.swift
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

import Factory
import Foundation
import Shared

enum GetSubscriptionsState {
    case idle
    case fetching
    case fetched(Subscriptions)
    case error(Error)
}

enum RestorePurchaseState {
    case idle
    case restoring
    case restored
    case error(Error)
}

@MainActor
final class PremiumPerksViewModel: ObservableObject {
    @Published private(set) var getSubscriptionsState: GetSubscriptionsState = .idle
    @Published private(set) var restorePurchaseState: RestorePurchaseState = .idle

    private let getSubscriptions = resolve(\SharedUseCaseContainer.getSubscriptions)

    var isGettingSubscriptions: Bool {
        if case .fetching = getSubscriptionsState {
            return true
        }
        return false
    }

    var isRestoring: Bool {
        if case .restoring = restorePurchaseState {
            return true
        }
        return false
    }

    var error: Error? {
        if case let .error(error) = getSubscriptionsState {
            return error
        } else if case let .error(error) = restorePurchaseState {
            return error
        }
        return nil
    }

    init() {}
}

extension PremiumPerksViewModel {
    func fetchSubscriptions() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                getSubscriptionsState = .fetching
                let subscriptions = try await getSubscriptions()
                getSubscriptionsState = .fetched(subscriptions)
            } catch {
                getSubscriptionsState = .error(error)
            }
        }
    }

    func restorePurchase() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                restorePurchaseState = .restoring
                try await Task.sleep(nanoseconds: 1_000_000_000)
                restorePurchaseState = .restored
            } catch {
                restorePurchaseState = .error(error)
            }
        }
    }

    func retry() {
        if case .error = getSubscriptionsState {
            fetchSubscriptions()
        } else if case .error = restorePurchaseState {
            restorePurchase()
        }
    }

    func resetStates() {
        getSubscriptionsState = .idle
        restorePurchaseState = .idle
    }
}
