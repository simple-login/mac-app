//
// LoggedInView.swift
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

import SimpleLoginPackage
import Shared
import SwiftUI

struct LoggedInView: View {
    @StateObject private var viewModel = LoggedInViewModel()

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case let .loaded(userInfo):
                view(for: userInfo)
            case let .error(error):
                view(for: error)
            }
        }
        .task {
            await viewModel.refreshUserInfo()
        }
    }
}

private extension LoggedInView {
    func view(for userInfo: UserInfo) -> some View {
        VStack {
            if let profilePictureUrl = userInfo.profilePictureUrl,
               let url = URL(string: profilePictureUrl) {
                AsyncImage(url: url)
            }
            Text(userInfo.name)
            Text(userInfo.email)
            Text(userInfo.isPremium ? "Premium" : "Free")

            if userInfo.inTrial {
                Text("In trial")
            }

            if let connectedProtonAddress = userInfo.connectedProtonAddress {
                Text("Connected to Proton account \(connectedProtonAddress)")
            }

            if !userInfo.isPremium {
                Button(action: {
                    print("Upgrade")
                }, label: {
                    Text("Upgrade")
                })
            }

            Button(action: {
                Task {
                    await viewModel.refreshUserInfo()
                }
            }, label: {
                Image(systemName: "arrow.circlepath")
            })
        }
    }
}

private extension LoggedInView {
    func view(for error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button(action: {
                Task {
                    await viewModel.refreshUserInfo()
                }
            }, label: {
                Image(systemName: "arrow.circlepath")
            })
        }
    }
}
