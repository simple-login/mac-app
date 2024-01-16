//
//  CFString+Extensions.swift
//
//
//  Created by Martin Lukacs on 18/11/2023.
//

import Foundation

extension CFString {
    var toString: String {
        self as String
    }
}

extension CFString: @unchecked Sendable {}
