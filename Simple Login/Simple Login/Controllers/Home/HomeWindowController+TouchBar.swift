//
//  HomeWindowController+TouchBar.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 27/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

private extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = "io.simplelogin.macapp.touchBar"
}

private extension NSTouchBarItem.Identifier {
    static let upgrade = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.upgrade")
    static let manageAliases = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.manageAliases")
    static let signOut = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.signOut")
    static let iOS = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.iOS")
    static let rating = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.rating")
    static let about = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.about")
    static let safari = NSTouchBarItem.Identifier("io.simplelogin.macapp.TouchBarItem.safari")
}

extension HomeWindowController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.upgrade, .manageAliases, .signOut, .fixedSpaceLarge, .iOS, .rating, .about, .fixedSpaceLarge, .safari]
        touchBar.customizationAllowedItemIdentifiers = [.upgrade, .manageAliases, .signOut, .fixedSpaceLarge, .iOS, .rating, .about, .safari]
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .upgrade:
            guard let userInfo = userInfo, !userInfo.isPremium else { return nil }
            let upgradeTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            upgradeTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Diamond"))!, target: self, action: #selector(upgradeButtonClicked))
            
            return upgradeTouchBarItem
            
        case .manageAliases:
            let manageAliasesTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            manageAliasesTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Management"))!, target: self, action: #selector(manageAliasesButtonClicked))
            
            return manageAliasesTouchBarItem
            
        case .signOut:
            let signOutTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            signOutTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("LogOut"))!, target: self, action: #selector(signOutButtonClicked))
            
            return signOutTouchBarItem
            
        case .iOS:
            let iOSTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            iOSTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("iOS"))!, target: self, action: #selector(iOSButtonClicked))
            
            return iOSTouchBarItem
            
        case .rating:
            let ratingTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            ratingTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Star"))!, target: self, action: #selector(ratingButtonClicked))
            
            return ratingTouchBarItem
            
        case .about:
            let aboutTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            aboutTouchBarItem.view = NSButton(image: NSImage(named: NSImage.Name("Info"))!, target: self, action: #selector(aboutButtonClicked))
            
            return aboutTouchBarItem
            
        case .safari:
            let safariTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            safariTouchBarItem.view = NSButton(title: "Open Safari", target: self, action: #selector(openSafari))
            
            return safariTouchBarItem
            
        default: return nil
        }
    }
}
