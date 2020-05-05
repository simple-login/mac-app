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
    
    static let rateAndSignOutGroup = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.rateAndSignOutGroup")
    static let rateUs = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.rateUs")
    static let signOut = NSTouchBarItem.Identifier("io.simplelogin.macapp.safariextension.touchBar.signOut")
}

// MARK: - NSTouchBarDelegate
extension ExtensionHomeViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        guard let _ = userOptions else { return nil }
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.centeredGroup, .fixedSpaceLarge, .rateAndSignOutGroup, .otherItemsProxy]
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
            
        case .rateAndSignOutGroup:
            let manageAndSignOutGroupItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
            manageAndSignOutGroupItem.customizationLabel = "Create & random alias"
            
            let touchBar = NSTouchBar()
            touchBar.delegate = self
            touchBar.defaultItemIdentifiers = [.rateUs, .signOut]
            
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
            
        case .rateUs:
            let manageAliasesTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            manageAliasesTouchBarItem.customizationLabel = "Rate Us"
            manageAliasesTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Star"))!, target: self, action: #selector(rateUs))
            
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
