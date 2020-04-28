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
    
    // MARK: - API Key
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
    
    // MARK: - API URL
    private static let API_URL = "API_URL"
    static func setApiUrl(_ apiUrl: String) {
        sharedUserDefaults?.set(apiUrl, forKey: API_URL)
    }
    
    static func getApiUrl() -> String {
        sharedUserDefaults?.string(forKey: API_URL) ?? "https://app.simplelogin.io"
    }
    
    // MARK: - Show Upgrade sheet
    private static let NEEDS_SHOW_UPGRADE_SHEET = "NEEDS_SHOW_UPGRADE_SHEET"
    
    static func needsShowUpgradeSheet() -> Bool {
        return sharedUserDefaults?.bool(forKey: NEEDS_SHOW_UPGRADE_SHEET) ?? false
    }
    
    static func setNeedsShowUpgradeSheet() {
        sharedUserDefaults?.set(true, forKey: NEEDS_SHOW_UPGRADE_SHEET)
    }
    
    static func finishShowingUpgradeSheet() {
        sharedUserDefaults?.set(false, forKey: NEEDS_SHOW_UPGRADE_SHEET)
    }
}
