//
//  ExtensionHomeViewController+TouchBar.swift
//  Safari Extension
//
//  Created by Thanh-Nhon Nguyen on 28/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import SafariServices

private extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = "io.simplelogin.macapp.safariextension.touchBar"
}

private extension NSTouchBarItem.Identifier {
    static let centeredGroup = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.centeredGroup")
    
    static let create = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.create")
    static let random = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.random")
    
    static let upgrade = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.upgrade")
    
    static let manageAndSignOutGroup = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.manageAndSignOutGroup")
    static let manageAliases = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.manageAliases")
    static let signOut = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.signOut")
}

private extension NSUserInterfaceItemIdentifier {
    static let itemViewIdentifier = NSUserInterfaceItemIdentifier(rawValue: "TextItemViewIdentifier")
}

// MARK: - NSTouchBarDelegate
extension ExtensionHomeViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        guard let userOptions = userOptions else { return nil }
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = userOptions.canCreate ?
            [.otherItemsProxy, .centeredGroup, .fixedSpaceLarge, .manageAndSignOutGroup] :
            [.otherItemsProxy, .centeredGroup, .fixedSpaceLarge, .manageAndSignOutGroup]
        touchBar.principalItemIdentifier = .centeredGroup
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .centeredGroup:
            let centeredGroupItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
            centeredGroupItem.customizationLabel = "Principal buttons"
            
            let touchBar = NSTouchBar()
            touchBar.delegate = self
            touchBar.defaultItemIdentifiers = userOptions!.canCreate ? [.create, .random] : [.upgrade]
            
            centeredGroupItem.groupTouchBar = touchBar
            
            return centeredGroupItem
            
        case .manageAndSignOutGroup:
            let manageAndSignOutGroupItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
            manageAndSignOutGroupItem.customizationLabel = "Create & random alias"
            
            let touchBar = NSTouchBar()
            touchBar.delegate = self
            touchBar.defaultItemIdentifiers = [.manageAliases, .signOut]
            
            manageAndSignOutGroupItem.groupTouchBar = touchBar
            
            return manageAndSignOutGroupItem
            
        case .create:
            let createTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            createTouchBarItem.customizationLabel = "Create Alias"
            
            let button = NSButton(title: "Create", target: self, action: #selector(createNewAlias))
            button.bezelColor = SLColor.tintColor
            createTouchBarItem.view = button
            
            return createTouchBarItem
            
        case .random:
            let randomTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            randomTouchBarItem.customizationLabel = "Random Alias"
            randomTouchBarItem.view = NSButton(title: "Random", target: self, action: #selector(createRandomlyNewAlias))
            
            return randomTouchBarItem
            
        case .upgrade:
            let upgradeTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            upgradeTouchBarItem.customizationLabel = "Upgrade for more superpowers"
            
            let button = NSButton(title: "Upgrade", target: self, action: #selector(upgrade))
            button.bezelColor = SLColor.tintColor
            
            upgradeTouchBarItem.view = button
            
            return upgradeTouchBarItem
            
        case .manageAliases:
            let manageAliasesTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            manageAliasesTouchBarItem.customizationLabel = "Manage your aliases"
            manageAliasesTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Management"))!, target: self, action: #selector(manageAliases))
            
            return manageAliasesTouchBarItem
            
        case .signOut:
            let signOutTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            signOutTouchBarItem.customizationLabel = "Sign out from SimpleLogin"
            signOutTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("LogOut"))!, target: self, action: #selector(signOut))
            
            return signOutTouchBarItem
            
        default: return nil
        }
    }
}
