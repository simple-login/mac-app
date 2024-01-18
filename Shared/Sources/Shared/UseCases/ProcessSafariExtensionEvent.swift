//
// ProcessSafariExtensionEvent.swift
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
//

import Foundation
import OSLog

public protocol ProcessSafariExtensionEventUseCase: Sendable {
    func execute(_ json: String) throws -> SafariExtensionEvent
}

public extension ProcessSafariExtensionEventUseCase {
    func callAsFunction(_ json: String) throws -> SafariExtensionEvent {
        try execute(json)
    }
}

public final class ProcessSafariExtensionEvent: ProcessSafariExtensionEventUseCase {
    public init() {}

    public func execute(_ json: String) throws -> SafariExtensionEvent {
        guard let data = json.data(using: .utf8) else {
            Logger.logError(with: "Not UTF8 data")
            throw SLError.notUtf8Data
        }

        guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            Logger.logError(with: "Bad JSON format")
            throw SLError.badJsonFormat
        }

        /*
         JSON samples

         {
            "logged_in": {
               "data": {
                  "api_key": "wchdottdlxewiewieqclewlbthkundbrefaqvzammryrwyavwknaewvf",
                  "api_url": "https://app.sldev.ovh"
               }
            }
         }

         {
            "logged_out": {}
         }

         {
            "upgrade": {}
         }

         */

        Logger.log(with: "[SimpleLogin] \(dict)")

        if let loggedIn = dict["logged_in"] as? [String: Any],
           let loggedInData = loggedIn["data"] as? [String: String],
           let apiKey = loggedInData["api_key"],
           let apiUrl = loggedInData["api_url"] {
            Logger.log(with: "Logged in event")
            return .loggedIn(apiUrl, apiKey)
        } else if dict["logged_out"] != nil {
            Logger.log(with: "Logged out event")
            return .loggedOut
        } else if dict["upgrade"] != nil {
            Logger.log(with: "Upgrade event")
            return .upgrade
        }

        Logger.log(with: "Unknown event")
        return .unknown
    }
}
