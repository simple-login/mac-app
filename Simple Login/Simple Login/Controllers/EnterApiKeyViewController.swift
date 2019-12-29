//
//  EnterApiKeyViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa

final class EnterApiKeyViewController: NSViewController {
    @IBOutlet private weak var welcomeLabel: NSTextField!
    @IBOutlet private weak var createAccountLabel: NSTextField!
    @IBOutlet private weak var createAndCopyApiKeyLabel: NSTextField!
    @IBOutlet private weak var apiKeyTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction private func setApiKey(_ sender: Any) {
        print("\(#function)")
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
                 .link : URL(string: "https://simplelogin.io/") as Any,
                 .toolTip : "https://simplelogin.io/"],
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
             .link : URL(string: "https://app.simplelogin.io/auth/register") as Any,
             .toolTip : "https://app.simplelogin.io/auth/register"],
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
             .link : URL(string: "https://app.simplelogin.io/dashboard/api_key") as Any,
             .toolTip : "https://app.simplelogin.io/dashboard/api_key"],
            range: NSRange(hereStringRange, in: createAndCopyApiKeyPlainString))
        }
        
        // If allowsEditingTextAttributes is not set to "true", when the user clicks the label, the attributedsStringValue is gone
        createAndCopyApiKeyLabel.allowsEditingTextAttributes = true
        createAndCopyApiKeyLabel.attributedStringValue = createAndCopyApiKeyAttributedString
    }
}
