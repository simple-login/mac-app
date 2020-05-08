//
//  EnterApiKeyViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa
import Alamofire

final class EnterApiKeyViewController: NSViewController {
    @IBOutlet private weak var rootStackView: NSStackView!
    @IBOutlet private weak var welcomeLabel: NSTextField!
    @IBOutlet private weak var createAccountLabel: NSTextField!
    @IBOutlet private weak var createAndCopyApiKeyLabel: NSTextField!
    @IBOutlet private weak var pasteApiKeyLabel: NSTextField!
    @IBOutlet private weak var apiKeyTextField: NSTextField!
    @IBOutlet private weak var apiUrlTextField: NSTextField!
    @IBOutlet private weak var setApiKeyButton: NSButton!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = NSSize(width: 600, height: 300)
        apiUrlTextField.stringValue = BASE_URL
        
        setLoading(false)
        setApiKeyButton.isEnabled = false
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func showNoInternetAlert() {
        let noInternetAlert = NSAlert()
        noInternetAlert.messageText = "No internet"
        noInternetAlert.informativeText = "Please check your internet connection"
        noInternetAlert.addButton(withTitle: "OK")
        noInternetAlert.alertStyle = .warning
        noInternetAlert.runModal()
    }
    
    @objc
    @IBAction func modifyApiUrl(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "Enter your custom API URL"
        alert.informativeText = "DO NOT change API URL unless you are hosting SimpleLogin with your own server. The default value is \"https://app.simplelogin.io\"."
        alert.addButton(withTitle: "Set API URL")
        alert.addButton(withTitle: "Reset to default value")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .critical
        
        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 400, height: 20))
        alert.accessoryView = input
        
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn:
            SLUserDefaultsService.setApiUrl(input.stringValue)
            apiUrlTextField.stringValue = input.stringValue
            
        case .alertSecondButtonReturn:
            SLUserDefaultsService.setApiUrl("https://app.simplelogin.io")
            apiUrlTextField.stringValue = "https://app.simplelogin.io"
            
        default: return
        }
    }
    
    @objc
    @IBAction func setApiKey(_ sender: Any) {
        let enteredApiKey = apiKeyTextField.stringValue
        
        guard enteredApiKey.count > 0 else { return }
        
        if (NetworkReachabilityManager()?.isReachable ?? false) == false {
            // No internet connection
            showNoInternetAlert()
            return
        }
        
        setLoading(true)
        
        SLApiService.fetchUserInfo(apiKey: enteredApiKey) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)
            
            self.progressIndicator.isHidden = true
            self.progressIndicator.stopAnimation(nil)
            
            switch result {
            case .success(let userInfo):
                SLUserDefaultsService.setApiKey(enteredApiKey)
                self.showHomeWindowController(with: userInfo)
                self.view.window?.performClose(nil)
                
            case .failure(let error):
                self.apiKeyTextField.stringValue = ""
                self.showErrorAlert(error)
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool, completelyHideOtherUis: Bool = false) {
        if (isLoading) {
            if completelyHideOtherUis {
                rootStackView.alphaValue = 0.0
            } else {
                rootStackView.alphaValue = 0.7
            }
            
            setApiKeyButton.isEnabled = false
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(self)
        } else {
            rootStackView.alphaValue = 1.0
            setApiKeyButton.isEnabled = true
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(self)
        }
    }
}

// MARK: - NSTextFieldDelegate
extension EnterApiKeyViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        setApiKeyButton.isEnabled = apiKeyTextField.stringValue.count > 0
    }
}
