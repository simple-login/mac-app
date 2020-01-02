//
//  SLUserDefaultsService.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 02/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation

final class SLUserDefaultsService {
    private static let sharedUserDefaults = UserDefaults(suiteName: "group.io.simplelogin.mac-app")
    private static let API_KEY = "API_KEY"
    
    static func setApiKey(_ apiKey: String) {
        sharedUserDefaults?.set(apiKey, forKey: API_KEY)
    }
    
    static func getApiKey() -> String? {
        return sharedUserDefaults?.string(forKey: API_KEY)
    }
    
    static func removeApiKey() {
        sharedUserDefaults?.set(nil, forKey: API_KEY)
    }
}
