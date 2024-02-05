//
// SafariWebExtensionHandler.swift
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

import Factory
import OSLog
import SafariServices
import Shared

final class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    private let processSafariExtensionEvent = resolve(\SharedUseCaseContainer.processSafariExtensionEvent)
    private let setApiUrl = resolve(\SharedUseCaseContainer.setApiUrl)
    private let setApiKey = resolve(\SharedUseCaseContainer.setApiKey)

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let message: Any?
        if #available(iOS 17.0, macOS 14.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        if let message {
            Task { [weak self] in
                await self?.handle(message: String(describing: message))
            }
        }
    }
}

private extension SafariWebExtensionHandler {
    func handle(message: String) async {
        Logger.log(with: "Received message \(message)")
        do {
            switch try processSafariExtensionEvent(message) {
            case let .loggedIn(apiUrl, apiKey):
                try await setApiUrl(apiUrl)
                try await setApiKey(apiKey)
            case .loggedOut:
                try await setApiKey(nil)
            case .upgrade:
                break
            case .unknown:
                break
            }
        } catch {
            Logger.logError(with: "Error handling message \(error.localizedDescription)")
            print(error.localizedDescription)
        }
    }
}

/*
 Default implementation of `beginRequest` function for reference

 func beginRequest(with context: NSExtensionContext) {
     let request = context.inputItems.first as? NSExtensionItem

     let profile: UUID?
     if #available(iOS 17.0, macOS 14.0, *) {
         profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
     } else {
         profile = request?.userInfo?["profile"] as? UUID
     }

     let message: Any?
     if #available(iOS 17.0, macOS 14.0, *) {
         message = request?.userInfo?[SFExtensionMessageKey]
     } else {
         message = request?.userInfo?["message"]
     }

     os_log(.default, "Received message from browser.runtime.sendNativeMessage: %{public}@ (profile: %{public}@)",
            String(describing: message),
            profile?.uuidString ?? "none")

     let response = NSExtensionItem()
     response.userInfo = [ SFExtensionMessageKey: [ "echo": message ] ]

     context.completeRequest(returningItems: [ response ], completionHandler: nil)
 }
 */
