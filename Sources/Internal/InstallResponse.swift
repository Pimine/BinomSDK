//  InstallResponse.swift
//  Copyright (c) 2021 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 01.04.2021

import Foundation

extension Binom {
struct InstallResponse: Decodable {
    
    // MARK: Properties
    
    let uuid: String
    let coupon: Bool
    let status: String
}}
