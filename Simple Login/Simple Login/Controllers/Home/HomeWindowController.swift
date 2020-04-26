//
//  HomeWindowController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 26/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

private extension NSToolbarItem.Identifier {
    static let userInfo = NSToolbarItem.Identifier(rawValue: "UserInfo")
    static let upgrade = NSToolbarItem.Identifier(rawValue: "Upgrade")
    static let manageAliases = NSToolbarItem.Identifier(rawValue: "ManageAliases")
    static let signOut = NSToolbarItem.Identifier(rawValue: "SignOut")
}

final class HomeWindowController: NSWindowController {
    @IBOutlet private weak var toolbar: NSToolbar!
    
    @IBOutlet private weak var userInfoView: NSView!
    @IBOutlet private weak var usernameLabel: NSTextField!
    @IBOutlet private weak var statusLabel: NSTextField!
    
    @IBOutlet private weak var upgradeView: NSView!
    @IBOutlet private weak var manageAliasesView: NSView!
    @IBOutlet private weak var signOutView: NSView!
    
    var userInfo: UserInfo?
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self, name: SLNotificationName.signOut, object: nil)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        
        (contentViewController as? HomeViewController)?.delegate = self
        
        // Observe sign out notification from safari extension
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(signOut), name: SLNotificationName.signOut, object: nil)
    }
    
    private func setUpUi() {
        guard let userInfo = userInfo else { return }
        usernameLabel.stringValue = userInfo.name
        
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

// MARK: - IBActions
extension HomeWindowController {
    @IBAction private func upgradeButtonClicked(_ sender: Any) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("IAP"), bundle: nil)
        let storyboardId = NSStoryboard.SceneIdentifier(stringLiteral: "IapViewController")
        let iapViewController = storyboard.instantiateController(withIdentifier: storyboardId) as! IapViewController
        contentViewController?.presentAsSheet(iapViewController)
    }
    
    @IBAction private func manageAliasesButtonClicked(_ sender: Any) {
        guard let url = URL(string: "\(BASE_URL)/dashboard".replacingOccurrences(of: "//", with: "/")) else { return }
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
        contentViewController?.showEnterApiKeyWindowController()
        close()
    }
}

// MARK: - NSToolbarDelegate
extension HomeWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.userInfo, .upgrade, .manageAliases, .signOut, .space, .flexibleSpace]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.userInfo, .flexibleSpace, .upgrade, .manageAliases, .signOut]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem = NSToolbarItem()
        
        switch itemIdentifier {
        case .userInfo:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.userInfo.rawValue, label: "", paletteLabel: "", toolTip: "Your username & status", itemContent: userInfoView)!
            
        case .upgrade:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.upgrade.rawValue, label: "", paletteLabel: "", toolTip: "Enhance your superpowers", itemContent: upgradeView)!
            
        case .manageAliases:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.manageAliases.rawValue, label: "", paletteLabel: "", toolTip: "Manages your aliases", itemContent: manageAliasesView)!
            
        case .signOut:
            toolbarItem = customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.signOut.rawValue, label: "", paletteLabel: "", toolTip: "Sign out from SimpleLogin", itemContent: signOutView)!
            
        default: break
        }
        
        return toolbarItem
    }
}


// MARK: - HomeViewControllerDelegate
extension HomeWindowController: HomeViewControllerDelegate {
    func homeViewControllerWillAppear() {
        setUpUi()
        if let userInfo = userInfo, userInfo.isPremium {
           removeUpgradeViewFromToolbar()
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
