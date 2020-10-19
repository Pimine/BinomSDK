//  SubscriptionUpdateParameters.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Foundation

public extension Binom {
struct SubscriptionUpdateParameters {
    
    // MARK: - Properties
    
    let uuid: Int
    let receipt: String
    let subscription: String
    let screenID: String
    let app: Int
}}

extension Binom.SubscriptionUpdateParameters {
    
    var json: Parameters {
        var params = Parameters()
        params["uuid"] = uuid
        params["receipt"] = receipt
        params["last_period"] = subscription
        params["screen"] = screenID
        params["app"] = app
        return params
    }
}
