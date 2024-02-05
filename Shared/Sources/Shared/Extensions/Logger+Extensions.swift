//
// Logger+Extensions.swift
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
//

import OSLog

public extension Logger {
    private static var subsystem = "SimpleLogin"

    // this could be changed
    static let error = Logger(subsystem: subsystem, category: "Error")
    static let infos = Logger(subsystem: subsystem, category: "Infos")

   static func logError(for type: String? = nil, with message: String) {
        #if DEBUG
       if let type {
           Logger.error.debug("\(type, align: .left(columns: type.count)) \(message)")
       } else {
           Logger.error.debug("\(message)")
       }
        #endif
    }

    /// ```swift
    /// Logger.log(for: "Login", with: "The message you want")
    /// ```
    static func log(for type: String? = nil, with message: String) {
        #if DEBUG
        if let type {
            Logger.infos.debug("\(type, align: .left(columns: type.count)) \(message)")
        } else {
            Logger.infos.debug("\(message)")
        }
        #endif
    }
}
