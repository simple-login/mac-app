//
// IAPView.swift
// SimpleLogin - Created on 19/01/2024.
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

struct IAPView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: IAPViewModelModel

    init(subscriptions: Subscriptions) {
        _viewModel = .init(wrappedValue: .init(subscriptions: subscriptions))
    }

    var body: some View {
        VStack {
            Text("IAP")
            Spacer()

            HStack {
                Button(action: dismiss.callAsFunction) {
                    Text("Cancel")
                }
            }
        }
        .frame(width: 400, height: 300)
    }
}
