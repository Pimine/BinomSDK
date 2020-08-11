//  BinomAPI.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 10.08.2020

import Moya

enum BinomAPI {
    /// Tracks install and response with UUID and coupon status.
    case trackInstall(Binom.InstallParameters?)
    
    /// Submit receipt with subscription info.
    case updateSubscription(Binom.SubscriptionUpdateParameters)
}

// MARK: - TargetType

extension BinomAPI: TargetType {
    
    public var baseURL: URL {
        return BinomManager.host
    }
    
    public var path: String {
        switch self {
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
        case .trackInstall(let params):
            return .requestParameters(
                parameters: params?.json ?? [:],
                encoding: JSONEncoding()
            )
        case .updateSubscription(let params):
            return .requestParameters(
                parameters: params.json,
                encoding: JSONEncoding()
            )
        }
    }
    
    public var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
