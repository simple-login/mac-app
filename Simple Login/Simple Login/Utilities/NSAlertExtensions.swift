//
//  NSAlertExtensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 04/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

extension NSAlert {
    convenience init(messageText: String, informativeText: String, buttonText: String, alertStyle: NSAlert.Style) {
        self.init()
        self.messageText = messageText
        self.informativeText = informativeText
        self.addButton(withTitle: buttonText)
        self.icon = NSImage(named: NSImage.Name(stringLiteral: "SimpleLogin"))
        self.alertStyle = alertStyle
    }
    
    convenience init(error: SLError) {
        self.init(messageText: "Error occured", informativeText: error.description, buttonText: "Close", alertStyle: .critical)
    }
    
    static func signOutAlert() -> NSAlert {
        let alert = NSAlert()
        alert.messageText = "Confirmation"
        alert.informativeText = "You will be signed out from Simple Login?"
        alert.addButton(withTitle: "Yes, sign me out")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .informational
        return alert
    }
}
