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
    @State private var subscriptions: Subscriptions?

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(width: 800, height: 480, alignment: .center)
            case let .loaded(userInfo, stats):
                view(userInfo: userInfo, stats: stats)
            case let .error(error):
                view(for: error)
            }
        }
        .task {
            await viewModel.refreshUserInfo()
        }
        .sheet(isPresented: subscriptionsBinding) {
            if let subscriptions {
                IAPView(subscriptions: subscriptions,
                        onUpgrade: { Task { await viewModel.refreshUserInfo() } })
            }
        }
    }
}

private extension LoggedInView {
    var subscriptionsBinding: Binding<Bool> {
        .init(get: {
            subscriptions != nil
        }, set: { newValue in
            if !newValue {
                subscriptions = nil
            }
        })
    }
}

private extension LoggedInView {
    func view(userInfo: UserInfo, stats: Stats) -> some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                LogoView()

                UserInfoView(userInfo: userInfo)
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                HStack(spacing: 16) {
                    StatCell(title: "Aliases", description: "All time", value: stats.aliasCount)
                    StatCell(title: "Forwarded", description: "Last 14 days", value: stats.forwardCount)
                }
                .padding(.bottom, 8)

                HStack(spacing: 16) {
                    StatCell(title: "Replies/sent", description: "Last 14 days", value: stats.replyCount)
                    StatCell(title: "Blocked", description: "Last 14 days", value: stats.blockCount)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if !userInfo.isPremium || userInfo.inTrial {
                PremiumPerksView(onUpgrade: { subscriptions = $0},
                                 onRestore: { Task { await viewModel.refreshUserInfo() } })
                .frame(maxWidth: 320)
            }
        }
        .padding(20)
        .frame(width: userInfo.isPremium ? 480 : 800, height: 480)
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
        .frame(width: 800, height: 480)
    }
}
