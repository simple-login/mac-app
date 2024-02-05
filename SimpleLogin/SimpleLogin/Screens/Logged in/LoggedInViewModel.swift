//
// LoggedInViewModel.swift
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
import SimpleLoginPackage
import Shared

enum LoggedInState {
    case loading
    case loaded(UserInfo, Stats)
    case error(Error)
}

@MainActor
final class LoggedInViewModel: ObservableObject {
    @Published private(set) var state: LoggedInState = .loading
    private let getApiUrl = resolve(\SharedUseCaseContainer.getApiUrl)
    private let getApiKey = resolve(\SharedUseCaseContainer.getApiKey)
    private let getUserInfo = resolve(\SharedUseCaseContainer.getUserInfo)
    private let getStats = resolve(\SharedUseCaseContainer.getStats)

    init() {}
}

extension LoggedInViewModel {
    func refreshUserInfo() async {
        do {
            state = .loading
            let apiUrl = try await getApiUrl()
            guard let apiKey = try await getApiKey() else {
                throw SLError.noApiKey
            }
            async let userInfoRequest = getUserInfo(apiUrl: apiUrl, apiKey: apiKey)
            async let statsRequest = getStats(apiUrl: apiUrl, apiKey: apiKey)
            let (userInfo, stats) = try await (userInfoRequest, statsRequest)
            state = .loaded(userInfo, stats)
        } catch {
            state = .error(error)
        }
    }
}
