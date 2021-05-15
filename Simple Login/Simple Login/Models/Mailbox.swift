//
//  Mailbox.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 15/05/2021.
//  Copyright © 2021 SimpleLogin. All rights reserved.
//

import Foundation

struct MailboxArray: Decodable {
    let mailboxes: [Mailbox]
}

struct Mailbox: Decodable {
    let id: Int
    let email: String
    let isDefault: Bool
    let numOfAlias: Int
    let creationTimestamp: TimeInterval
    let isVerified: Bool

    private enum Key: String, CodingKey {
        case id = "id"
        case email = "email"
        case isDefault = "default"
        case numOfAlias = "nb_alias"
        case creationTimestamp = "creation_timestamp"
        case isVerified = "verified"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.isDefault = try container.decode(Bool.self, forKey: .isDefault)
        self.numOfAlias = try container.decode(Int.self, forKey: .numOfAlias)
        self.creationTimestamp = try container.decode(TimeInterval.self, forKey: .creationTimestamp)
        self.isVerified = try container.decode(Bool.self, forKey: .isVerified)
    }
}
