//
//  ApiKeyMissingViewController.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 30/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import SafariServices

final class ApiKeyMissingViewController: SFSafariExtensionViewController {
    static let shared: ApiKeyMissingViewController = {
        let shared = ApiKeyMissingViewController()
        shared.preferredContentSize = NSSize(width:320, height:100)
        return shared
    }()
    
    @IBAction private func openHostApp(_ sender: Any) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        
        // bundleIdentifier is "io.simplelogin.Simple-Login.Safari-Extension""
        // remove the last subdomain to retrieve the host app's bundle identifier
        guard let lastIndexOfDot = bundleIdentifier.lastIndex(of: ".") else { return }
        
        let hostAppBundleIdentifier = String(bundleIdentifier[..<lastIndexOfDot])
        
        NSWorkspace.shared.launchApplication(withBundleIdentifier: hostAppBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}

