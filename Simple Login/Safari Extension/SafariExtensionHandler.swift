//
//  SafariExtensionHandler.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 30/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        
//        if (messageName == "FinishLoadingPage") {
//            let hostname = userInfo?["hostname"] as? String ?? ""
//        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
//        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
//        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        if let apiKey = SLUserDefaultsService.getApiKey() {
            ExtensionHomeViewController.shared.apiKey = apiKey
            return ExtensionHomeViewController.shared
        } else {
            return ApiKeyMissingViewController.shared
        }
    }
}
