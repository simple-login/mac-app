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
    @IBOutlet private weak var apiKeyTextField: NSTextField!
    @IBOutlet private weak var setApiKeyButton: NSButton!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setLoading(false)
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
    
    @IBAction private func setApiKey(_ sender: Any) {
        if (NetworkReachabilityManager()?.isReachable ?? false) == false {
            // No internet connection
            showNoInternetAlert()
            return
        }
        
        setLoading(true)
        
        let enteredApiKey = apiKeyTextField.stringValue
        SLApiService.fetchUserInfo(enteredApiKey, completion: { [weak self] (userInfo, error) in
            guard let self = self else { return }
            
            self.progressIndicator.isHidden = true
            self.progressIndicator.stopAnimation(nil)
            
            if let error = error {
                self.showErrorAlert(error)
            } else if let userInfo = userInfo {
                SLUserDefaultsService.setApiKey(enteredApiKey)
                self.openInstructionViewController(with: userInfo)
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
    private func setupLabels() {
        setupWelcomeLabel()
        setupCreateAccountLabel()
        setupCreateAndCopyApiKeyLabel()
    }
    
    private func setupWelcomeLabel() {
        let welcomePlainString = "Welcome to SimpleLogin ↗, the most powerful email alias solution!"
        
        let welcomeAttributedString = NSMutableAttributedString(string: welcomePlainString)
        welcomeAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 20), range: NSMakeRange(0, welcomePlainString.count))
        
        if let simpleLoginStringRange = welcomePlainString.range(of: "SimpleLogin ↗") {
            welcomeAttributedString.addAttributes(
                [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
                 .font : NSFont.systemFont(ofSize: 20, weight: .medium),
                 .underlineStyle : NSUnderlineStyle.single.rawValue,
                 .link : URL(string: BASE_URL) as Any,
                 .toolTip : BASE_URL],
                range: NSRange(simpleLoginStringRange, in: welcomePlainString))
            
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        welcomeLabel.allowsEditingTextAttributes = true
        welcomeLabel.attributedStringValue = welcomeAttributedString
    }
    
    private func setupCreateAccountLabel() {
        let createAccountPlainString = "Create your SimpleLogin account here if this is not already done."
        
        let createAccountAttributedString = NSMutableAttributedString(string: createAccountPlainString)
        createAccountAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAccountPlainString.count))
        
        if let hereStringRange = createAccountPlainString.range(of: "here") {
            createAccountAttributedString.addAttributes(
            [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
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
        let createAndCopyApiKeyPlainString = "Create and copy your API Key here."
        
        let createAndCopyApiKeyAttributedString = NSMutableAttributedString(string: createAndCopyApiKeyPlainString)
        createAndCopyApiKeyAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSMakeRange(0, createAndCopyApiKeyPlainString.count))
        
        if let hereStringRange = createAndCopyApiKeyPlainString.range(of: "here") {
            createAndCopyApiKeyAttributedString.addAttributes(
            [.foregroundColor : NSColor(named: NSColor.Name(stringLiteral: "HyperlinkColor")) ?? NSColor.blue,
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
