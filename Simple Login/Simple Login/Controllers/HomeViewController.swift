//
//  HomeViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa

final class HomeViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction private func openSafari(_ sender: Any) {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.apple.safari", options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}
