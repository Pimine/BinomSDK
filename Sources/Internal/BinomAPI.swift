//  BinomAPI.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 10.08.2020

import Moya
import Foundation

enum BinomAPI {
    /// Tries to auth client with provided key.
    case auth(Binom.AuthParameters)
    
    /// Tracks install and response with UUID and coupon status.
    case trackInstall(Binom.InstallParameters?)
    
    /// Submit receipt with subscription info.
    case updateSubscription(Binom.SubscriptionUpdateParameters)
}

// MARK: - TargetType

extension BinomAPI: TargetType {
    
    public var baseURL: URL {
        return BinomManager.shared.configuration.host
    }
    
    public var path: String {
        switch self {
        case .auth:
            return "/auth/"
        case .trackInstall:
            return "/track_install/"
        case .updateSubscription:
            return "/subscription_update/"
        }
    }
    
    public var method: Moya.Method { .post }
    
    public var sampleData: Data { Data() }
    
    public var task: Task {
        switch self {
        case .auth(let params):
            return .requestJSONEncodable(params)
        case .trackInstall(let params):
            return .requestParameters(
                parameters: params?.json ?? [:],
                encoding: JSONEncoding.default
            )
        case .updateSubscription(let params):
            return .requestParameters(
                parameters: params.json,
                encoding: JSONEncoding.default
            )
        }
    }
    
    public var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
