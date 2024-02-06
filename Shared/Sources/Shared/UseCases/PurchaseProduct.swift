//
// PurchaseProduct.swift
// SimpleLogin - Created on 06/02/2024.
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
//

import Foundation
import StoreKit

public protocol PurchaseProductUseCase: Sendable {
    func execute(_ product: Product) async throws -> Transaction?
}

public extension PurchaseProductUseCase {
    @discardableResult
    func callAsFunction(_ product: Product) async throws -> Transaction? {
        try await execute(product)
    }
}

public final class PurchaseProduct: PurchaseProductUseCase {
    public init() {}

    public func execute(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
}

private extension PurchaseProduct {
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SLError.failedPurchaseVerification
        case let .verified(safe):
            return safe
        }
    }
}
