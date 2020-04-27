//
//  HomeViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Cocoa

protocol HomeViewControllerDelegate {
    func homeViewControllerDidAppear()
}

final class HomeViewController: NSViewController {
    @IBOutlet private weak var enableExtensionLabel: NSTextField!
    @IBOutlet private weak var step1Label: NSTextField!
    @IBOutlet private weak var step2Label: NSTextField!
    @IBOutlet private weak var step3Label: NSTextField!
    
    var delegate: HomeViewControllerDelegate?

    override func viewWillAppear() {
        super.viewWillAppear()
        if let _ = SLUserDefaultsService.getApiKey() {
            setupUI()
        } else {
            showEnterApiKeyWindowController()
            view.window?.close()
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        delegate?.homeViewControllerDidAppear()
    }
    
    @IBAction private func openSafari(_ sender: Any) {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.apple.safari", options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
    
    private func setupUI() {
        setupStep1Label()
        setupStep2Label()
        setupStep3Label()
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
