//
//  NSMutableAttributedStringExtensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 06/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

extension NSMutableAttributedString {
    func addTextAlignCenterAttribute() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count))
    }
}
