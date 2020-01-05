//
//  SFSafariExtensionVCExtensions.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 05/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import SafariServices

extension SFSafariExtensionViewController {
    func openHostApp() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        
        // bundleIdentifier is "io.simplelogin.Simple-Login.Safari-Extension""
        // remove the last subdomain to retrieve the host app's bundle identifier
        guard let lastIndexOfDot = bundleIdentifier.lastIndex(of: ".") else { return }
        
        let hostAppBundleIdentifier = String(bundleIdentifier[..<lastIndexOfDot])
        
        NSWorkspace.shared.launchApplication(withBundleIdentifier: hostAppBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}
