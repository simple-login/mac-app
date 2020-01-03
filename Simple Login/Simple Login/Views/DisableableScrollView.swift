//
//  DisableableScrollView.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

@IBDesignable
class DisableableScrollView: NSScrollView {
    @IBInspectable
    @objc(enabled)
    public var isScrollEnabled: Bool = true
    
    override func scrollWheel(with event: NSEvent) {
        if isScrollEnabled {
            super.scrollWheel(with: event)
        }
    }
}
