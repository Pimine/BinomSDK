//  BinomInstallParameters.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Foundation

public extension Binom {
struct InstallParameters {
    
    // MARK: - Properties
    
    public let coupon: String
    public let app: Int
    public let screen: String
    public let clickID: String?
    
    // MARK: - Initialization
    
    public init(coupon: String, app: Int, screen: String, clickID: String?) {
        self.coupon = coupon
        self.app = app
        self.screen = screen
        self.clickID = clickID
    }
}}

// MARK: - JSON

extension Binom.InstallParameters {
    
    var json: Parameters {
        var params = Parameters()
        params["coupon"] = coupon
        params["app"] = app
        params["screen"] = screen
        params["clickid"] = clickID
        return params
    }
}
