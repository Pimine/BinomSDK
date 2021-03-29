//  AuthParameters.swift
//  Copyright (c) 2021 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 25.03.2021

import Foundation

extension Binom {
    struct AuthParameters: Codable {
    
    // MARK: Parameters
    
    let app: Int
    let uuid: String
    let key: String
}}
