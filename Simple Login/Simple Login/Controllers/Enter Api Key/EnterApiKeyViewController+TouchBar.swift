//
//  EnterApiKeyViewController+TouchBar.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 27/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

private extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = "io.simplelogin.macapp.enterapi.touchBar"
}

private extension NSTouchBarItem.Identifier {
    static let enterApiKeyGroup = NSTouchBarItem.Identifier(rawValue: "io.simplelogin.macapp.enterapi.TouchBarItem.enterApiKeyGroup")
    static let setApiKey = NSTouchBarItem.Identifier(rawValue: "io.simplelogin.macapp.enterapi.TouchBarItem.setApiKey")
    static let modifyUrl = NSTouchBarItem.Identifier(rawValue: "io.simplelogin.macapp.enterapi.TouchBarItem.modifyUrl")
}

extension EnterApiKeyViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.enterApiKeyGroup, .otherItemsProxy]
        touchBar.principalItemIdentifier = .enterApiKeyGroup
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .enterApiKeyGroup:
            let enterApiKeyGroupTouchBarItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)

            let touchBar = NSTouchBar()
            touchBar.delegate = self
            touchBar.defaultItemIdentifiers = [.setApiKey, .modifyUrl]

            enterApiKeyGroupTouchBarItem.groupTouchBar = touchBar

            return enterApiKeyGroupTouchBarItem

        case .setApiKey:
            let setApiKeyTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            setApiKeyTouchBarItem.customizationLabel = "Set API Key"
            let button = NSButton(title: "Set API Key", target: self, action: #selector(setApiKey))
            button.bezelColor = SLColor.tintColor
            setApiKeyTouchBarItem.view = button
            
            return setApiKeyTouchBarItem
            
        case .modifyUrl:
            let modifyUrlTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            modifyUrlTouchBarItem.customizationLabel = "Modify API URL"
            modifyUrlTouchBarItem.view = NSButton(title: "Modify API URL", target: self, action: #selector(modifyApiUrl))
            
            return modifyUrlTouchBarItem
            
        default: return nil
        }
    }
}
