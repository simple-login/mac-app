//
// MainView.swift
// SimpleLogin - Created on 09/01/2024.
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

import Shared
import SwiftUI

struct MainView: View {
    @Environment(\.controlActiveState) var controlActiveState
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            view(for: viewModel.state)
        }
        .animation(.default, value: viewModel.state)
        .onChange(of: controlActiveState) { controlActiveState in
            switch controlActiveState {
            case .active, .key:
                Task {
                    await viewModel.refreshState()
                }
            default:
                break
            }
        }
    }
}

private extension MainView {
    @ViewBuilder
    func view(for state: MainViewModelState) -> some View {
        switch state {
        case .loading:
            ProgressView()
        case .safariExtensionDisabled:
            ExtensionDisabledView()
        case .loggedOut:
            LoggedOutView()
        case .loggedIn:
            LoggedInView()
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}
