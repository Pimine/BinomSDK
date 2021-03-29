//  BackendError.swift
//  Copyright (c) 2021 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 29.03.2021

import Foundation

extension Binom {
struct BackendError: Decodable {

    let error: String
    let code: Int
}}
