//
// LoggedOutView.swift
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

import SwiftUI

struct LoggedOutView: View {
    @StateObject private var viewModel = LoggedOutViewModel()

    var body: some View {
        VStack(alignment: .center) {
            LogoView()
                .padding(.vertical, 50)
            HStack {
                step1
                Divider()
                step2
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 800, height: 480)
    }
}

private extension LoggedOutView {
    func stepNumber(_ number: Int) -> some View {
        Text("\(number)")
            .padding(8)
            .background(Color.blue)
            .clipShape(Circle())
    }

    func stepDescription(_ description: String) -> some View {
        Text("Enable SimpleLogin in Safari Extensions preferences.")
            .multilineTextAlignment(.center)
            .font(.headline.weight(.medium))
    }

    func stepImage(_ named: String) -> some View {
        Image(named)
            .resizable()
            .scaledToFit()
    }

    var step1: some View {
        VStack(alignment: .center) {
            stepNumber(1)
            stepDescription("Enable SimpleLogin in Safari Extensions preferences.")
            Button(action: viewModel.openSafariPreferences) {
                Text("Open Safari Preferences")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.blue)
            stepImage("Step1")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    var step2: some View {
        VStack(alignment: .center) {
            stepNumber(2)
            stepDescription("Sign into your SimpleLogin account.")
            Spacer()
            stepImage("Step2")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LoggedOutView()
}
