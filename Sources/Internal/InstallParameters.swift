//  BinomInstallParameters.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Foundation

extension Binom {
struct InstallParameters {
    
    // MARK: Properties
    
    let screen: String?
    let clickID: String?
    let token: String
}}

// MARK: - JSON

extension Binom.InstallParameters {
    
    var json: Parameters {
        var params = Parameters()
        params["screen"] = screen
        params["clickid"] = clickID
        params["token"] = token
        return params
    }
}
