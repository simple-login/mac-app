//
//  User.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Foundation

struct User {
    let canCreateCustom: Bool
    let suffixes: [String]
    let suggestion: String
    let existingAliases: [String]
    
    init(fromData data: Data) throws {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw SLError.failToSerializeJSONData
        }
        
        let canCreateCustom = jsonDictionary["can_create_custom"] as? Bool
        let existingAliases = jsonDictionary["existing"] as? [String]
        let customDictionary = jsonDictionary["custom"] as? [String : Any]
        let suffixes = customDictionary?["suffixes"] as? [String]
        let suggestion = customDictionary?["suggestion"] as? String
        
        if let canCreateCustom = canCreateCustom,
            let existingAliases = existingAliases,
            let suffixes = suffixes,
            let suggestion = suggestion {
            self.canCreateCustom = canCreateCustom
            self.suffixes = suffixes
            self.suggestion = suggestion
            self.existingAliases = existingAliases
        } else {
            throw SLError.failToParseUser
        }
    }
}
