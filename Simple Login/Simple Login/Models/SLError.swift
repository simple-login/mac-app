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
    case failToParseObject(objectName: String)
    case invalidApiKey
    case duplicatedAlias
    case internalServerError
    case badGateway
    case emptySuffix
    case unknownResponseStatusCode
    case badRequest(description: String)
    case unknownErrorWithStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var description: String {
        switch self {
        case .noData: return "Server isn't responding. Please try again later."
        case .failToSerializeJSONData: return "Failed to serialize JSON data"
        case .failToParseObject(let objectName): return "Failed to parse \(objectName)"
        case .invalidApiKey: return "Invalid API key"
        case .duplicatedAlias: return "Alias is duplicated"
        case .internalServerError: return "Internal server error"
        case .badGateway: return "Bad gateway error"
        case .unknownResponseStatusCode: return "Unknown response status code"
        case .emptySuffix: return "No suffix is selected"
        case .badRequest(let description): return "Bad request: \(description)"
        case .unknownErrorWithStatusCode(let statusCode): return "Unknown error with status code \(statusCode)"
        case .unknownError(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    func toParameter() -> [String: Any] {
        return ["error": description]
    }
}
