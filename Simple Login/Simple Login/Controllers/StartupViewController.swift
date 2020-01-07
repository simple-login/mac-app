//
//  StartupViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 07/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa
import Alamofire

final class StartupViewController: NSViewController {
    @IBOutlet private weak var messageLabel: NSTextField!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var actionButton: NSButton!
    
    private var dataRequest: DataRequest?
    private var apiKey: String?
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Retrieve API key from user defaults
        // API key exists -> verify it
        // API not exist -> open EnterApiKeyWindowController
        if let apiKey = SLUserDefaultsService.getApiKey() {
            self.apiKey = apiKey
            checkApiKeyAndProceed()
        } else {
            openEnterApiKeyWindowController()
        }
    }
    
    @IBAction private func actionButtonClicked(_ sender: Any) {
        guard let dataRequest = dataRequest else { return }
        
//        switch dataRequest.state {
//        case .cancelled:
//            <#code#>
//        default:
//            <#code#>
//        }
    }
    
    private func checkApiKeyAndProceed() {
        dataRequest = SLApiService.fetchUserInfo(apiKey!, completion: { [weak self] (userInfo, error) in
            guard let self = self else { return }
            
        })
    }
    
    private func openEnterApiKeyWindowController() {
        let storyboardName = NSStoryboard.Name(stringLiteral: "EnterApiKey")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "EnterApiKeyWindowControllerID")
        
        if let enterApiKeyWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
            enterApiKeyWindowController.showWindow(nil)
            view.window?.performClose(nil)
        }
    }
}
