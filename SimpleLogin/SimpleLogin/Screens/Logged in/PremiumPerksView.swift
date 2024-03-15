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
import Shared

struct PremiumPerksView: View {
    @StateObject private var viewModel = PremiumPerksViewModel()

    var onUpgrade: (Shared.Subscriptions) -> Void
    var onRestore: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Discover Premium")
                .font(.title.bold())
                .padding(.bottom)
            Spacer()
            perks
            Spacer()

            Group {
                upgradeButton
                restoreButton
            }
            .disabled(viewModel.isGettingSubscriptions || viewModel.isRestoring)
        }
        .padding()
        .roundedBorderedBackground()
        .onReceive(viewModel.$restorePurchaseState) { state in
            if case .restored = state {
                onRestore()
                viewModel.resetStates()
            }
        }
        .onReceive(viewModel.$getSubscriptionsState) { state in
            if case let .fetched(subscriptions) = state {
                onUpgrade(subscriptions)
                viewModel.resetStates()
            }
        }
        .alert(
            "Error occured",
            isPresented: errorBinding,
            actions: {
                Button("Cancel", role: .cancel, action: { viewModel.resetStates() })
                Button("Retry", action: { viewModel.retry() })
            },
            message: {
                Text(viewModel.error?.userFacingMessage ?? "")
            })
    }
}

private extension PremiumPerksView {
    var errorBinding: Binding<Bool> {
        .init(get: {
            viewModel.error != nil
        }, set: { newValue in
            if !newValue {
                viewModel.resetStates()
            }
        })
    }
}

private extension PremiumPerksView {
    var perks: some View {
        VStack(spacing: 12) {
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

private extension PremiumPerksView {
    var upgradeButton: some View {
        Button(action: {
            if case .idle = viewModel.getSubscriptionsState {
                viewModel.fetchSubscriptions()
            }
        }, label: {
            if case .fetching = viewModel.getSubscriptionsState {
                ZStack {
                    Text(verbatim: "Dummy text")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.clear)
                        .padding(8)
                    ProgressView()
                        .controlSize(.mini)
                }
            } else {
                Text("Upgrade")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(8)
            }
        })
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
        .tint(Color.blue)
        .padding(.vertical)
    }
}

private extension PremiumPerksView {
    var restoreButton: some View {
        Button(action: {
            if case .idle = viewModel.restorePurchaseState {
                viewModel.restorePurchase()
            }
        }, label: {
            if case .restoring = viewModel.restorePurchaseState {
                ZStack {
                    Text(verbatim: "Dummy text")
                        .foregroundStyle(Color.clear)
                    ProgressView()
                        .controlSize(.mini)
                }
            } else {
                Text("Restore purchase")
                    .foregroundStyle(Color.blue)
            }
        })
        .frame(maxWidth: .infinity, alignment: .center)
        .buttonStyle(.borderless)
    }
}

#Preview {
    PremiumPerksView(onUpgrade: { _ in }, onRestore: {})
        .padding()
        .preferredColorScheme(.dark)
}
