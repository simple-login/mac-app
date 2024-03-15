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
    private let onUpgrade: () -> Void

    init(subscriptions: Shared.Subscriptions, onUpgrade: @escaping () -> Void) {
        _viewModel = .init(wrappedValue: .init(subscriptions: subscriptions))
        self.onUpgrade = onUpgrade
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            closeButton
                .padding()

            VStack(alignment: .leading) {
                Text("Go premium")
                    .font(.title.bold())
                yearlyButton
                yearlyDescription
                monthlyButton
                    .padding(.vertical)
                manageSubscriptionText
                tosLink
                privacyLink
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()

            if case .upgrading = viewModel.upgradeState {
                cover
            }
        }
        .frame(width: 400, height: 280)
        .animation(.default, value: viewModel.upgradeState)
        .alert(
            "You're all set",
            isPresented: upgradedBinding,
            actions: {
                Button("Close") {
                    dismiss()
                    onUpgrade()
                }
            },
            message: {
                Text("Thank you for subscribing. Enjoy our premium service.")
            })
        .alert(
            "Error occured",
            isPresented: errorBinding,
            actions: {
                Button("Cancel", role: .cancel, action: {})
                Button("Retry", action: { viewModel.retry() })
            },
            message: {
                Text(viewModel.upgradeState.error?.userFacingMessage ?? "")
            })
    }
}

private extension IAPView {
    var upgradedBinding: Binding<Bool> {
        .init(get: {
            if case .upgraded = viewModel.upgradeState {
                return true
            }
            return false
        }, set: { _ in })
    }

    var errorBinding: Binding<Bool> {
        .init(get: {
            viewModel.upgradeState.error != nil
        }, set: { _ in })
    }

    var closeButton: some View {
        Button(action: dismiss.callAsFunction) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 18)
        }
        .buttonStyle(.borderless)
    }

    var cover: some View {
        ZStack {
            Color.black.opacity(0.4)
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension IAPView {
    var yearlyButton: some View {
        Button(
            action: { viewModel.subscribeYearly() },
            label: {
                Text("Subscribe yearly \(viewModel.subscriptions.yearly.displayPrice)/year")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            })
        .buttonStyle(.borderedProminent)
        .tint(Color.blue)
    }

    var yearlyDescription: some View {
        Text("Save 2 months by subscribing yearly")
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.secondary)
    }

    var monthlyButton: some View {
        Button(
            action: { viewModel.subscribeMonthly() },
            label: {
                Text("Subscribe monthly \(viewModel.subscriptions.monthly.displayPrice)/month")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            })
    }
}

private extension IAPView {
    var manageSubscriptionText: some View {
        // swiftlint:disable:next line_length
        Text("Subscription can be managed and canceled at anytime by going to System Settings → Media and Purchases → Subscriptions")
            .font(.caption.weight(.light))
            .foregroundStyle(Color.secondary)
    }

    @ViewBuilder
    var tosLink: some View {
        if let url = URL(string: "https://simplelogin.io/terms/") {
            Link(destination: url, label: { Text("Terms and Conditions") })
                .font(.caption)
        }
    }

    @ViewBuilder
    var privacyLink: some View {
        if let url = URL(string: "https://simplelogin.io/privacy/") {
            Link(destination: url, label: { Text("Privacy Policy") })
                .font(.caption)
        }
    }
}
