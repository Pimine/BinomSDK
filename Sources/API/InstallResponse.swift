//  InstallResponse.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Pimine

public extension Binom {
struct InstallResponse {
    let uuid: Int
    let isCouponValid: Bool
}}

// MARK: - Decodable

extension Binom.InstallResponse: Decodable {
    
    enum RootKeys: String, CodingKey {
        case success
        case data
    }
    
    enum DataKeys: String, CodingKey {
        case uuid
        case isCouponValid = "coupon"
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        guard try container.decode(Bool.self, forKey: .success) else {
            throw PMGeneralError(message: "Received response with failure status.")
        }

        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        uuid = try dataContainer.decode(Int.self, forKey: .uuid)
        isCouponValid = try dataContainer.decode(Bool.self, forKey: .isCouponValid)
    }
}
