//
//  NSImage+Extensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 26/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

extension NSImage {
    func setTint(_ tintColor: NSColor) {
        lockFocus()
        tintColor.set()
        let rect = NSRect(origin: .zero, size: size)
        rect.fill(using: .sourceAtop)
        unlockFocus()
    }
}
