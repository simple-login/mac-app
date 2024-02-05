//
// PremiumPerksView.swift
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

struct PremiumPerksView: View {
    var onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Discover Premium")
                .font(.title.bold())
                .padding(.bottom)

            Spacer()

            perks

            Spacer()

            Button(action: onUpgrade) {
                Text("Upgrade")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(8)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color.blue)
            .padding(.top)
        }
        .padding()
        .roundedBorderedBackground()
    }
}

private extension PremiumPerksView {
    var perks: some View {
        VStack(spacing: 16) {
            ForEach(PremiumPerk.allCases, id: \.self) { perk in
                row(for: perk)
            }
        }
    }

    func row(for perk: PremiumPerk) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
                .foregroundStyle(Color.blue)
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading) {
                Text(perk.title)
                    .foregroundStyle(Color.primary)
                if let description = perk.description {
                    Text(description)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PremiumPerksView(onUpgrade: {})
        .padding()
        .preferredColorScheme(.dark)
}
