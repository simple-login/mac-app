//
// ContentView.swift
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

struct ContentView: View {
    @Environment(\.controlActiveState) var controlActiveState
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        ZStack {
            if let error = viewModel.error {
                errorView(error)
            } else {
                statusView(viewModel.status)
            }
        }
        .animation(.default, value: viewModel.status)
        .onChange(of: controlActiveState) { controlActiveState in
            switch controlActiveState {
            case .active, .key:
                Task {
                    await viewModel.checkExtensionStatus()
                }
            default:
                break
            }
        }
    }
}

private extension ContentView {
    func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
    }
}

private extension ContentView {
    @ViewBuilder
    func statusView(_ status: SafariExtensionCheckingStatus) -> some View {
        switch status {
        case .inProgress:
            ProgressView()
        case let .done(enabled):
            if enabled {
                Text("Extension is enabled")
            } else {
                Text("Extension is not enabled")
            }
        case .error(let error):
            errorView(error)
        }
    }
}

#Preview {
    ContentView()
}
