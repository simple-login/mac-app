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

import Foundation

enum PlanState {
    case loading
    case loaded
    case error(Error)
}

enum UpgradeState {
    case upgrading
    case upgraded
    case error(Error)
}

@MainActor
final class IAPViewModelModel: ObservableObject {
    @Published private(set) var planState: PlanState = .loading
    @Published private(set) var upgradeState: UpgradeState = .upgrading

    init() {}

    func upgrade() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                upgradeState = .upgrading
                try await Task.sleep(nanoseconds: 1_000_000_000)
            } catch {
                upgradeState = .error(error)
            }
        }
    }
}
