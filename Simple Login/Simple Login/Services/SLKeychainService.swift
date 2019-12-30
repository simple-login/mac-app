//
//  SLKeychainService.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 30/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Foundation
import KeychainAccess

final class SLKeychainService {
    private static let keychain = Keychain(service: "io.simplelogin.mac-app")
    private static let API_KEY = "API_KEY"
    
    static func setApiKey(_ apiKey: String) {
        keychain[API_KEY] = apiKey
    }
    
    static func getApiKey() -> String? {
        return keychain[API_KEY]
    }
    
    static func removeApiKey() {
        keychain[API_KEY] = nil
    }
}
