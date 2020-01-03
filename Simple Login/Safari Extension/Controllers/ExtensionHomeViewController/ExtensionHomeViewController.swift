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
    
    // Outlets
    @IBOutlet private weak var rootStackView: NSStackView!
    @IBOutlet private weak var hostnameTextField: NSTextField!
    @IBOutlet private weak var suffixLabel: NSTextField!
    @IBOutlet private weak var manageAliasesButton: NSTextField!
    @IBOutlet private weak var signOutButton: NSTextField!
    
    var apiKey: String?
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = rootStackView.intrinsicContentSize
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        getURL { [unowned self] (url) in
            guard let hostname = url?.host, let apiKey = self.apiKey else { return }
            SLApiService.fetchUserData(apiKey: apiKey, hostname: hostname) { [weak self] (user, error) in
                guard let self = self else { return }
                
                if let error = error {
                    switch error {
                    case .invalidApiKey:
                        // TODO: Open host app for user to enter a valid api key
                        return
                    default:
                        // TODO: Display error
                        return
                    }
                } else if let user = user {
                    self.hostnameTextField.stringValue = user.suggestion
                    self.suffixLabel.stringValue = user.suffixes[0]
                }
            }
        }
    }
    
    private func getURL(_ completion: @escaping (_ url: URL?) -> Void) {
        SFSafariApplication.getActiveWindow { (window) in
            window?.getActiveTab(completionHandler: { (tab) in
                tab?.getActivePage(completionHandler: { (page) in
                    page?.getPropertiesWithCompletionHandler({ (properties) in
                        completion(properties?.url)
                    })
                })
            })
        }
    }
}
