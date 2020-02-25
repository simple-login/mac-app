//
//  Statics.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation

var BASE_URL: String {
    get {
        SLUserDefaultsService.getApiUrl()
    }
}

let ALIAS_PREFIX_MAX_LENGTH = 100
