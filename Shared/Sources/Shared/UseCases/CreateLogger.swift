//
// CreateLogger.swift
// SimpleLogin - Created on 16/02/2024.
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
import OSLog

public protocol CreateLoggerUseCase: Sendable {
    func execute(category: String) -> Logger
}

public extension CreateLoggerUseCase {
    func callAsFunction(category: String) -> Logger {
        execute(category: category)
    }
}

public final class CreateLogger: CreateLoggerUseCase {
    public init() {}

    public func execute(category: String) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "SimpleLogin", category: category)
    }
}
