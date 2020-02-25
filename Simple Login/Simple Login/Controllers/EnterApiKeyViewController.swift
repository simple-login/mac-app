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
        setupUI()
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
    
    @IBAction private func modifyApiUrl(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "Enter your custom API URL"
        alert.addButton(withTitle: "Set API URL")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .informational
        
        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 20))
        alert.accessoryView = input
        
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn:
            SLUserDefaultsService.setApiUrl(input.stringValue)
            apiUrlTextField.stringValue = input.stringValue
            
        default: return
        }
    }
    
    @IBAction private func setApiKey(_ sender: Any) {
        let enteredApiKey = apiKeyTextField.stringValue
        
        guard enteredApiKey.count > 0 else { return }
        
        if (NetworkReachabilityManager()?.isReachable ?? false) == false {
            // No internet connection
            showNoInternetAlert()
            return
        }
        
        setLoading(true)
        
        SLApiService.fetchUserInfo(enteredApiKey, completion: { [weak self] (userInfo, error) in
            guard let self = self else { return }
            self.setLoading(false)
            
            self.progressIndicator.isHidden = true
            self.progressIndicator.stopAnimation(nil)
            
            if let error = error {
                self.showErrorAlert(error)
            } else if let userInfo = userInfo {
                SLUserDefaultsService.setApiKey(enteredApiKey)
                self.openInstructionViewController(with: userInfo)
                self.view.window?.performClose(nil)
            }
        })
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
    
    private func showInstructionViewController() {
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "InstructionViewController")
        if let instructionViewController = storyboard!.instantiateController(withIdentifier: storyboardID) as? InstructionViewController {
            view.window?.contentViewController = instructionViewController
        }
    }
}

// MARK: Set up labels
extension EnterApiKeyViewController {
    private func setupUI() {
        preferredContentSize = NSSize(width: 600, height: 300)
        apiUrlTextField.stringValue = BASE_URL
        setupCreateAccountLabel()
        setupCreateAndCopyApiKeyLabel()
    }
    
    private func setupCreateAccountLabel() {
        let createAccountPlainString = "Create your SimpleLogin account here ↗"
        
        let createAccountAttributedString = NSMutableAttributedString(string: createAccountPlainString)
        createAccountAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAccountPlainString.count))
        
        if let hereStringRange = createAccountPlainString.range(of: "here ↗") {
            createAccountAttributedString.addAttributes(
                [.foregroundColor : NSColor.systemTeal,
             .font : NSFont.systemFont(ofSize: 13, weight: .medium),
             .underlineStyle : NSUnderlineStyle.single.rawValue,
             .link : URL(string: "\(BASE_URL)/auth/register") as Any,
             .toolTip : "\(BASE_URL)/auth/register"],
            range: NSRange(hereStringRange, in: createAccountPlainString))
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        createAccountLabel.allowsEditingTextAttributes = true
        createAccountLabel.attributedStringValue = createAccountAttributedString
    }
    
    private func setupCreateAndCopyApiKeyLabel() {
        let createAndCopyApiKeyPlainString = "Create and copy your API Key ↗"
        
        let createAndCopyApiKeyAttributedString = NSMutableAttributedString(string: createAndCopyApiKeyPlainString)
        createAndCopyApiKeyAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAndCopyApiKeyPlainString.count))
        
        if let hereStringRange = createAndCopyApiKeyPlainString.range(of: "API Key ↗") {
            createAndCopyApiKeyAttributedString.addAttributes(
                [.foregroundColor : NSColor.systemTeal,
             .font : NSFont.systemFont(ofSize: 13, weight: .medium),
             .underlineStyle : NSUnderlineStyle.single.rawValue,
             .link : URL(string: "\(BASE_URL)/dashboard/api_key") as Any,
             .toolTip : "\(BASE_URL)/dashboard/api_key"],
            range: NSRange(hereStringRange, in: createAndCopyApiKeyPlainString))
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        createAndCopyApiKeyLabel.allowsEditingTextAttributes = true
        createAndCopyApiKeyLabel.attributedStringValue = createAndCopyApiKeyAttributedString
    }
}

// MARK: - NSTextFieldDelegate
extension EnterApiKeyViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        setApiKeyButton.isEnabled = apiKeyTextField.stringValue.count > 0
    }
}
