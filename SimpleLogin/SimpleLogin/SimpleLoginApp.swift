//
// SimpleLoginApp.swift
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

import Shared
import SwiftUI

@main
struct SimpleLoginApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .contentSizeWindowResizability()
        .commands {
            CommandGroup(replacing: .newItem) {}
            DebugMenu()
        }
    }
}

private extension Scene {
    func contentSizeWindowResizability() -> some Scene {
        if #available(macOS 13, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}

private struct DebugMenu: Commands {
    @AppStorage(Constants.logEnabledKey, store: kSharedUserDefaults)
    private var logEnabled = false

    var body: some Commands {
        CommandMenu("Debug") {
            Toggle(isOn: $logEnabled, label: {
                Text("Enable logging")
            })
        }
    }
}
