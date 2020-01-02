//
//  SLError.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Foundation

enum SLError: Error, CustomStringConvertible {
    case failToParseUser
    
    var description: String {
        switch self {
        case .failToParseUser: return "Failed to parse user's info"
        }
    }
}
