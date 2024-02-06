//
// GetSubscriptions.swift
// Proton Pass - Created on 06/02/2024.
// Copyright (c) 2024 Proton Technologies AG
//
// This file is part of Proton Pass.
//
// Proton Pass is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Proton Pass is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Proton Pass. If not, see https://www.gnu.org/licenses/.
//

import Foundation
import StoreKit

public protocol GetSubscriptionsUseCase: Sendable {
    func execute() async throws -> Subscriptions
}

public extension GetSubscriptionsUseCase {
    func callAsFunction() async throws -> Subscriptions {
        try await execute()
    }
}

public final class GetSubscriptions: GetSubscriptionsUseCase {
    public init() {}

    public func execute() async throws -> Subscriptions {
        let monthlyId = "me.proton.simplelogin.macos.premium.monthly"
        let yearlyId = "me.proton.simplelogin.macos.premium.yearly"
        let products = try await Product.products(for: [monthlyId, yearlyId])

        guard let monthlySubscription = products.first(where: { $0.id == monthlyId}) else {
            throw SLError.missingMonthlySubscription
        }

        guard let yearlySubscription = products.first(where: { $0.id == yearlyId }) else {
            throw SLError.missingYearlySubscription
        }

        return .init(monthly: monthlySubscription, yearly: yearlySubscription)
    }
}
