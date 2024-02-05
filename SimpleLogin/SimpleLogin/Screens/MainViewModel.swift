//
// MainViewModel.swift
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
import SimpleKeychain
import Shared

enum MainViewModelState {
    case loading
    case safariExtensionDisabled
    case loggedIn
    case loggedOut
    case error(Error)
}

@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var state: MainViewModelState = .loading

    private let getSafariExtensionState = resolve(\SharedUseCaseContainer.getSafariExtensionState)
    private let getApiUrl = resolve(\SharedUseCaseContainer.getApiUrl)
    private let getApiKey = resolve(\SharedUseCaseContainer.getApiKey)

    init() {}
}

extension MainViewModel {
    func refreshState() async {
        do {
            if case .error = state {
                state = .loading
            }

            let safariExtensionState = try await getSafariExtensionState(bundleId: Constants.extensionBundleId)
            if safariExtensionState.isEnabled {
                if try await getApiKey() != nil {
                    state = .loggedIn
                } else {
                    state = .loggedOut
                }
            } else {
                state = .safariExtensionDisabled
            }
        } catch {
            if let keychainError = error as? SimpleKeychainError,
                case .itemNotFound = keychainError {
                // Ignore item not found error
                state = .loggedOut
                return
            }
            state = .error(error)
        }
    }
}

extension MainViewModelState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.safariExtensionDisabled, .safariExtensionDisabled),
            (.loggedIn, .loggedIn),
            (.loggedOut, .loggedOut):
            return true
        case let (.error(lError), .error(rError)):
            return lError.localizedDescription == rError.localizedDescription
        default:
            return false
        }
    }
}
