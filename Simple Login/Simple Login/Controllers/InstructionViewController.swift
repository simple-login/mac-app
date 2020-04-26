//
//  InstructionViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa

final class InstructionViewController: NSViewController {
    @IBOutlet private weak var usernameLabel: NSTextField!
    @IBOutlet private weak var statusLabel: NSTextField!
    @IBOutlet private weak var upgradeButton: NSButton!
    @IBOutlet private weak var enableExtensionLabel: NSTextField!
    @IBOutlet private weak var step1Label: NSTextField!
    @IBOutlet private weak var step2Label: NSTextField!
    @IBOutlet private weak var step3Label: NSTextField!
    
    var userInfo: UserInfo?

    override func viewWillAppear() {
        super.viewWillAppear()
        if let _ = SLUserDefaultsService.getApiKey() {
            setupUI()
        } else {
            openEnterApiKeyWindowController()
            view.window?.close()
        }
        
        // Observe sign out notification from safari extension
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(signOut), name: SLNotificationName.signOut, object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self, name: SLNotificationName.signOut, object: nil)
    }
    
    @IBAction private func openSafari(_ sender: Any) {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.apple.safari", options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
    
    private func setupUI() {
        preferredContentSize = NSSize(width: 800, height: 600)
        setupStep1Label()
        setupStep2Label()
        setupStep3Label()
        
        guard let userInfo = userInfo else { return }
        usernameLabel.stringValue = userInfo.name
        
        if userInfo.inTrial {
            statusLabel.stringValue = "Premium trial"
            statusLabel.textColor = .systemTeal
            upgradeButton.isHidden = false
        } else if userInfo.isPremium {
            statusLabel.stringValue = "Premium"
            statusLabel.textColor = .systemGreen
            upgradeButton.isHidden = true
        } else {
            statusLabel.stringValue = "Free plan"
            statusLabel.textColor = .labelColor
            upgradeButton.isHidden = false
        }
    }
    
    private func setupStep1Label() {
        let plainString = "Step 1️⃣: Open Safari > Preferences...(or use the hotkey ⌘,)"
        
        let attributedString = NSMutableAttributedString(string: plainString)
        
        ["Step 1️⃣:", "Safari", "Preferences...", "⌘,"].forEach { (string) in
            if let stringRange = plainString.range(of: string) {
                attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13, weight: .semibold), range: NSRange(stringRange, in: plainString))
            }
        }
        
        step1Label.isSelectable = false
        step1Label.allowsEditingTextAttributes = true
        step1Label.attributedStringValue = attributedString
    }
    
    private func setupStep2Label() {
        let plainString = "Step 2️⃣: Select Extensions tab and then ✔️ on SimpleLogin"
        
        let attributedString = NSMutableAttributedString(string: plainString)
        
        ["Step 2️⃣:", "Extensions", "Simple Login"].forEach { (string) in
            if let stringRange = plainString.range(of: string) {
                attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13, weight: .semibold), range: NSRange(stringRange, in: plainString))
            }
        }
        
        step2Label.isSelectable = false
        step2Label.allowsEditingTextAttributes = true
        step2Label.attributedStringValue = attributedString
    }
    
    private func setupStep3Label() {
        let plainString = "Step 3️⃣: 🎉🎉🎉 SimpleLogin Safari Extension is now available on your Safari among other extensions next to the address bar"
        
        let attributedString = NSMutableAttributedString(string: plainString)
        
        ["Step 3️⃣:", "SimpleLogin Safari Extension"].forEach { (string) in
            if let stringRange = plainString.range(of: string) {
                attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13, weight: .semibold), range: NSRange(stringRange, in: plainString))
            }
        }
        
        step3Label.isSelectable = false
        step3Label.allowsEditingTextAttributes = true
        step3Label.attributedStringValue = attributedString
    }
}

// MARK: - IBActions
extension InstructionViewController {
    @IBAction private func upgradeButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction private func manageAliasesButtonClicked(_ sender: Any) {
        guard let url = URL(string: "\(BASE_URL)/dashboard") else { return }
        NSWorkspace.shared.open(url)
    }
    
    @IBAction private func signOutButtonClicked(_ sender: Any) {
        let alert = NSAlert.signOutAlert()
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn: signOut()
        default: return
        }
    }
    
    @objc private func signOut() {
        SLUserDefaultsService.removeApiKey()
        openEnterApiKeyWindowController()
        view.window?.performClose(nil)
    }
}
