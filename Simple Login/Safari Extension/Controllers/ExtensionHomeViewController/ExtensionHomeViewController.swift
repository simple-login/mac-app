//
//  ExtensionHomeViewController.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 30/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import SafariServices

final class ExtensionHomeViewController: SFSafariExtensionViewController {
    static let shared: ExtensionHomeViewController = {
        let shared = ExtensionHomeViewController()
        shared.preferredContentSize = NSSize(width:320, height:400)
        return shared
    }()
    
    @IBOutlet private weak var apiKeyLabel: NSTextField!
    
    var apiKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiKeyLabel.stringValue = apiKey ?? "API Key is null"
    }
}
