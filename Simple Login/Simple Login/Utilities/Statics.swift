//
//  Statics.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

var BASE_URL: String {
    get {
        SLUserDefaultsService.getApiUrl()
    }
}

let ALIAS_PREFIX_MAX_LENGTH = 100

typealias ApiKey = String

let preciseDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM yyyy 'at' HH:mm"
    return dateFormatter
}()

// Activiy activity icons
let blockImage: NSImage = {
    let image = NSImage(named: NSImage.Name("BlockIcon"))!
    image.setTint(.systemRed)
    return image
}()

let forwardImage: NSImage = {
    let image = NSImage(named: NSImage.Name("PaperPlaneIcon"))!
    image.setTint(.secondaryLabelColor)
    return image
}()

let replyImage: NSImage = {
    let image = NSImage(named: NSImage.Name("ReplyIcon"))!
    image.setTint(.secondaryLabelColor)
    return image
}()

let clockImage: NSImage = {
    let image = NSImage(named: NSImage.Name("ClockIcon"))!
    image.setTint(.secondaryLabelColor)
    return image
}()

let waveImage: NSImage = {
    let image = NSImage(named: NSImage.Name("WaveIcon"))!
    image.setTint(.secondaryLabelColor)
    return image
}()
