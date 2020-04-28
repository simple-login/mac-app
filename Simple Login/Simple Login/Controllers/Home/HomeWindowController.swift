//
//  HomeWindowController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 26/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

private extension NSToolbarItem.Identifier {
    static let userInfoItem = NSToolbarItem.Identifier(rawValue: "UserInfo")
    static let upgrade = NSToolbarItem.Identifier(rawValue: "Upgrade")
    static let manageAliases = NSToolbarItem.Identifier(rawValue: "ManageAliases")
    static let signOut = NSToolbarItem.Identifier(rawValue: "SignOut")
    static let ios = NSToolbarItem.Identifier(rawValue: "iOS")
    static let rating = NSToolbarItem.Identifier(rawValue: "Rating")
    static let about = NSToolbarItem.Identifier(rawValue: "About")
}

final class HomeWindowController: NSWindowController {
    @IBOutlet private weak var toolbar: NSToolbar!
    
    @IBOutlet private weak var userInfoView: NSView!
    @IBOutlet private weak var avatarImageView: NSImageView!
    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var emailLabel: NSTextField!
    @IBOutlet private weak var statusLabel: NSTextField!
    
    @IBOutlet private weak var upgradeView: NSView!
    @IBOutlet private weak var manageAliasesView: NSView!
    @IBOutlet private weak var signOutView: NSView!
    
    @IBOutlet private weak var iOSView: NSView!
    @IBOutlet private weak var ratingView: NSView!
    @IBOutlet private weak var aboutView: NSView!
    
    var userInfo: UserInfo?
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self, name: SLNotificationName.signOut, object: nil)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        toolbar.allowsUserCustomization = true
        
        nameLabel.stringValue = ""
        emailLabel.stringValue = ""
        statusLabel.stringValue = ""
        
        (contentViewController as? HomeViewController)?.delegate = self

        // Observe sign out notification from safari extension
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(signOut), name: SLNotificationName.signOut, object: nil)
    }
    
    private func customToolbarItem(
        itemForItemIdentifier itemIdentifier: String,
        label: String,
        paletteLabel: String,
        toolTip: String,
        itemContent: AnyObject) -> NSToolbarItem? {
        
        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: itemIdentifier))
        
        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip
        toolbarItem.target = self
        
        // Set the right attribute, depending on if we were given an image or a view.
        if itemContent is NSImage {
            if let image = itemContent as? NSImage {
                toolbarItem.image = image
            }
        } else if itemContent is NSView {
            if let view = itemContent as? NSView {
                toolbarItem.view = view
            }
        } else {
            assertionFailure("Invalid itemContent: object")
        }
        
        return toolbarItem
    }
}

// MARK: - HomeViewControllerDelegate
extension HomeWindowController: HomeViewControllerDelegate {
    func homeViewControllerDidAppear() {
        guard let userInfo = userInfo else { return }
        nameLabel.stringValue = userInfo.name
        emailLabel.stringValue = userInfo.email
        
        if userInfo.inTrial {
            statusLabel.stringValue = "Premium trial"
            statusLabel.textColor = .systemGreen
        } else if userInfo.isPremium {
            statusLabel.stringValue = "Premium"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.stringValue = "Free plan"
            statusLabel.textColor = .labelColor
        }
        
        if userInfo.isPremium {
            removeUpgradeViewFromToolbar()
        }
        
        // Check if app is opened from Safari Extension to upgrade
        if SLUserDefaultsService.needsShowUpgradeSheet() {
            upgradeButtonClicked("")
            SLUserDefaultsService.finishShowingUpgradeSheet()
        }
    }

    private func removeUpgradeViewFromToolbar() {
        for (index, item) in toolbar.items.enumerated() {
            if item.itemIdentifier == .upgrade {
                toolbar.removeItem(at: index)
                return
            }
        }
    }
}

// MARK: - IBActions
extension HomeWindowController {
    @objc @IBAction func upgradeButtonClicked(_ sender: Any) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("IAP"), bundle: nil)
        let storyboardId = NSStoryboard.SceneIdentifier(stringLiteral: "IapViewController")
        let iapViewController = storyboard.instantiateController(withIdentifier: storyboardId) as! IapViewController
        contentViewController?.presentAsSheet(iapViewController)
    }
    
    @objc @IBAction func manageAliasesButtonClicked(_ sender: Any) {
        guard let url = URL(string: "\(BASE_URL)/dashboard".replacingOccurrences(of: "//", with: "/")) else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc @IBAction func signOutButtonClicked(_ sender: Any) {
        let alert = NSAlert.signOutAlert()
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn: signOut()
        default: return
        }
    }
    
    @objc private func signOut() {
        SLUserDefaultsService.removeApiKey()
        contentViewController?.showEnterApiKeyWindowController()
        close()
    }
    
    @objc @IBAction func iOSButtonClicked(_ sender: Any) {
        guard let url = URL(string: "https://apps.apple.com/us/app/simplelogin-anti-spam/id1494359858") else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc @IBAction func ratingButtonClicked(_ sender: Any) {
        guard let url = URL(string: "https://apps.apple.com/us/app/simplelogin/id1494051017?action=write-review") else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc @IBAction func aboutButtonClicked(_ sender: Any) {
        guard let url = URL(string: "https://simplelogin.io/about/") else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc func openSafari() {
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.apple.safari", options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}

// MARK: - NSToolbarDelegate
extension HomeWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.userInfoItem, .upgrade, .manageAliases, .signOut, .ios, .rating, .about, .space, .flexibleSpace]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.userInfoItem, .flexibleSpace, .upgrade, .manageAliases, .signOut, .space, .ios, .rating, .about]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem = NSToolbarItem()
        
        switch itemIdentifier {
        case .userInfoItem:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.userInfoItem.rawValue, label: "", paletteLabel: "", toolTip: "Your display name & status", itemContent: userInfoView)!
            
        case .upgrade:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.upgrade.rawValue, label: "", paletteLabel: "", toolTip: "Enhance your superpowers", itemContent: upgradeView)!
            
        case .manageAliases:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.manageAliases.rawValue, label: "", paletteLabel: "", toolTip: "Manages your aliases", itemContent: manageAliasesView)!
            
        case .signOut:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.signOut.rawValue, label: "", paletteLabel: "", toolTip: "Sign out from SimpleLogin", itemContent: signOutView)!
            
        case .ios:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.ios.rawValue, label: "", paletteLabel: "", toolTip: "SimpleLogin on iOS", itemContent: iOSView)!
            
        case .rating:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.rating.rawValue, label: "", paletteLabel: "", toolTip: "Rate us", itemContent: ratingView)!
            
        case .about:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.about.rawValue, label: "", paletteLabel: "", toolTip: "Our team", itemContent: aboutView)!
            
        default: break
        }
        
        return toolbarItem
    }
}
