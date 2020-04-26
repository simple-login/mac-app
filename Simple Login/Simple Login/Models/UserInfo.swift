//
//  UserInfo.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 07/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

class UserInfo {
    let name: String
    let email: String
    private(set) var isPremium: Bool
    let inTrial: Bool
    
    lazy private(set) var attributedString: NSAttributedString = {
        let premiumOrUpgrade = isPremium ? "Premium" : "Freemium"
        let plainString = "\(name)\n\(premiumOrUpgrade)"
        
        let attributedString = NSMutableAttributedString(string: plainString)
        
        attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 16, weight: .semibold), range: NSMakeRange(0, plainString.count))
        
        if let premiumOrUpgradeRange = plainString.range(of: premiumOrUpgrade) {
            if isPremium {
                attributedString.addAttributes(
                    [.font : NSFont.systemFont(ofSize: 14, weight: .light),
                     .foregroundColor: NSColor.systemGreen], range: NSRange(premiumOrUpgradeRange, in: plainString))
            } else {
                attributedString.addAttributes(
                [.foregroundColor : NSColor.systemBlue,
                 .font : NSFont.systemFont(ofSize: 14, weight: .medium)],
                range: NSRange(premiumOrUpgradeRange, in: plainString))
            }
        }
        
        return attributedString
    }()
    
    init(fromData data: Data) throws {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw SLError.failToSerializeJSONData
        }
        
        let name = jsonDictionary["name"] as? String
        let email = jsonDictionary["email"] as? String
        let isPremium = jsonDictionary["is_premium"] as? Bool
        let inTrial = jsonDictionary["in_trial"] as? Bool
        
        if let name = name, let email = email, let isPremium = isPremium, let inTrial = inTrial {
            self.name = name
            self.email = email
            self.isPremium = isPremium
            self.inTrial = inTrial
        } else {
            throw SLError.failToParseObject(objectName: "UserInfo")
        }
    }
    
    func setIsPremium(_ isPremium: Bool) {
        self.isPremium = isPremium
    }
}
