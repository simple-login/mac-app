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

import Shared
import SwiftUI

struct LoggedInView: View {
    @StateObject private var viewModel: LoggedInViewModel

    init(apiUrl: ApiUrl,  apiKey: ApiKey) {
        _viewModel = .init(wrappedValue: .init(apiUrl: apiUrl, apiKey: apiKey))
    }

    var body: some View {
        VStack {
            Text("You're logged in")
        }
    }
}
