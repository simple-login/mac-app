//
//  IapViewController+TouchBar.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 27/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

private extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = "io.simplelogin.macapp.iap.touchBar"
}

private extension NSTouchBarItem.Identifier {
    /// Cancel IapViewController
    static let cancel = NSTouchBarItem.Identifier("io.simplelogin.macapp.iap.TouchBarItem.cancel")
}

extension IapViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.flexibleSpace, .cancel, .flexibleSpace]
        touchBar.customizationAllowedItemIdentifiers = [.flexibleSpace, .cancel]
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let cancelTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
        let button = NSButton(title: "Cancel", target: self, action: #selector(cancelButtonTapped))
        button.bezelColor = SLColor.tintColor
        cancelTouchBarItem.view = button
        
        return cancelTouchBarItem
    }
}
