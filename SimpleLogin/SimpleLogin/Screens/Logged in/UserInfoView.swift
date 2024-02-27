//
// UserInfoView.swift
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

import SwiftUI
import SimpleLoginPackage

struct UserInfoView: View {
    let userInfo: UserInfo

    var body: some View {
        HStack {
            avatar

            VStack(alignment: .leading) {
                Text(userInfo.name)
                    .font(.headline.weight(.medium))
                Text(userInfo.email)
                    .foregroundStyle(Color.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            if let status = userInfo.subscriptionStatus {
                Text(status)
                    .font(.body.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(10)
        .roundedBorderedBackground()
    }
}

private extension UserInfoView {
    @ViewBuilder
    var avatar: some View {
        if let profilePictureUrl = userInfo.profilePictureUrl,
           let url = URL(string: profilePictureUrl) {
            AsyncImage(url: url)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ZStack {
                Color.blue.opacity(0.2)
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(Color.blue)
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

private extension UserInfo {
    var subscriptionStatus: String? {
        if inTrial {
            "Trial"
        } else if isPremium {
            "Premium"
        } else {
            nil
        }
    }
}

#Preview {
    UserInfoView(userInfo: .init(name: "Eric Nobert",
                                 email: "eric.nobert@proton.me",
                                 profilePictureUrl: nil,
                                 isPremium: true,
                                 inTrial: false,
                                 maxAliasFreePlan: 10,
                                 connectedProtonAddress: nil,
                                 canCreateReverseAlias: true))
        .padding()
        .preferredColorScheme(.dark)
}
