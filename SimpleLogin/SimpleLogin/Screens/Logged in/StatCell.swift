//
// StatCell.swift
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

struct StatCell: View {
    let title: String
    let description: String
    let value: Int

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Text(description)
                    .foregroundStyle(Color.secondary)
                    .fontWeight(.medium)
            }

            Text("\(value)")
                .font(.system(size: 40).weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .roundedBorderedBackground()
    }
}

#Preview {
    StatCell(title: "Aliases",
             description: "All time",
             value: 1_234)
    .frame(width: 250)
    .padding()
    .preferredColorScheme(.dark)
}
