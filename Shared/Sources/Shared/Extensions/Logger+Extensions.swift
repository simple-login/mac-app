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

    static let error = Logger(subsystem: subsystem, category: "Error")
    static let info = Logger(subsystem: subsystem, category: "Info")

    /*
     While in development (debug mode), all logs are shown in Xcode console
     but only warning & error logs are shown in Console app.
     Not sure why so we fallback to warning when not in debug mode
     */

    func publicDebug(_ message: String) {
        #if DEBUG
        debug("\(message, privacy: .public)")
        #else
        warning("\(message, privacy: .public)")
        #endif
    }

    func publicInfo(_ message: String) {
        #if DEBUG
        info("\(message, privacy: .public)")
        #else
        warning("\(message, privacy: .public)")
        #endif
    }

    func publicWarning(_ message: String) {
        warning("\(message, privacy: .public)")
    }

    func publicError(_ message: String) {
        error("\(message, privacy: .public)")
    }
}
