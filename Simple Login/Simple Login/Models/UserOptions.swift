//
//  UserOptions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 29/12/2019.
//  Copyright © 2019 SimpleLogin. All rights reserved.
//

import Foundation

struct Suffix: Decodable {
    let value: String
    let signature: String

    // swiftlint:disable:next type_name
    private enum Key: String, CodingKey {
        case value = "suffix"
        case signature = "signed_suffix"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.signature = try container.decode(String.self, forKey: .signature)
    }

    init(value: String, signature: String) {
        self.value = value
        self.signature = signature
    }
}

struct UserOptions: Decodable {
    let canCreate: Bool
    let prefixSuggestion: String
    let suffixes: [Suffix]

    lazy var domains: [String] = {
        var domains: [String] = []

        suffixes.forEach { suffix in
            if let domain = RegexHelpers.firstMatch(for: #"(?<=@).*"#, inString: suffix.value) {
                domains.append(domain)
            }
        }

        return domains
    }()

    // swiftlint:disable:next type_name
    private enum Key: String, CodingKey {
        case canCreate = "can_create"
        case prefixSuggestion = "prefix_suggestion"
        case suffixes = "suffixes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        self.canCreate = try container.decode(Bool.self, forKey: .canCreate)
        self.prefixSuggestion = try container.decode(String.self, forKey: .prefixSuggestion)
        self.suffixes = try container.decode([Suffix].self, forKey: .suffixes)
    }
}
