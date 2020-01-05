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
        openHostApp()
    }
}

