//
//  SLError.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Foundation

enum SLError: Error, CustomStringConvertible {
    case noData
    case failToSerializeJSONData
    case failToParseUser
    case invalidApiKey
    case unknownError(description: String)
    
    var description: String {
        switch self {
        case .noData: return "Server returns no data"
        case .failToSerializeJSONData: return "Failed to serialize JSON data"
        case .failToParseUser: return "Failed to parse user's info"
        case .invalidApiKey: return "Invalid API key"
        case .unknownError(let description): return "Unknown error: \(description)"
        }
    }
}
