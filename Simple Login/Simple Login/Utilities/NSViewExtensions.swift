//
//  NSViewExtensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 04/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

extension NSView {
    func disableSubviews(_ disabled: Bool) {
        for eachSubview in subviews {
            if let control = eachSubview as? NSControl {
                control.isEnabled = !disabled
            }
        }
    }
}
