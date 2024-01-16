//
//  SimpleKeychainError.swift
//
//
//  Created by Martin Lukacs on 18/11/2023.
//

import Foundation

public enum SimpleKeychainError: Error, Equatable {
   case invalidData
   case itemNotFound
   case duplicateItem
   case incorrectAttributeForClass
   case unexpected(OSStatus)

   var localizedDescription: String {
      switch self {
      case .invalidData:
         return "Invalid data"
      case .itemNotFound:
         return "Item not found"
      case .duplicateItem:
         return "Duplicate Item"
      case .incorrectAttributeForClass:
         return "Incorrect Attribute for Class"
      case .unexpected(let oSStatus):
         return "Unexpected error - \(oSStatus)"
      }
   }
}

extension OSStatus {
    var toSimpleKeychainError: SimpleKeychainError {
        switch self {
        case errSecItemNotFound:
           return .itemNotFound
        case errSecDataTooLarge:
           return .invalidData
        case errSecDuplicateItem:
           return .duplicateItem
        default:
           return .unexpected(self)
        }
    }
}
