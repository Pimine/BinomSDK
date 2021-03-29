//  Token.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 16.12.2020

import Foundation

extension Binom {
struct Token {
    
    // MARK: Properties
    
    let token: String
    let expiredAt: Date
    
    // MARK: Helpers
    
    var needRefresh: Bool {
        expiredAt.adding(.hour, value: -6) < Date()
    }
}}

// MARK: - Decodable

extension Binom.Token: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case token
        case expiredAt = "exp"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        self.expiredAt = try container.decode(Date.self, forKey: .expiredAt)
    }
}
