//  BinomProvider.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Moya
import PromiseKit
import PimineUtilities
import Foundation

final class BinomProvider {
    
    // MARK: - Properties
    
    private let provider = MoyaProvider<BinomAPI>()
    private let decoder = JSONDecoder()
    
    // MARK: - Tasks
    
    func authenticate(_ params: Binom.AuthParameters) -> Promise<Binom.Token> {
        Promise { seal in
            provider.request(.auth(params)) { requestResult in
                switch requestResult {
                case .success(let response):
                    guard let token = try? response.map(Binom.Token.self, atKeyPath: "data", using: self.decoder) else {
                        let backendError = try? response.map(Binom.BackendError.self, atKeyPath: "data", using: self.decoder)
                        let error = PMGeneralError(message: backendError?.error ?? PMessages.somethingWentWrong)
                        return seal.reject(error)
                    }
                    return seal.fulfill(token)
                case .failure(let error):
                    return seal.reject(error)
                }
            }
        }
    }
    
    func trackInstall(_ params: Binom.InstallParameters?) -> Promise<String> {
        Promise { seal in
            provider.request(.trackInstall(params)) { (requestResult) in
                switch requestResult {
                case .success(let response):
                    guard let installResponse = try? response.map(Binom.InstallResponse.self, atKeyPath: "data", using: self.decoder) else {
                        let backendError = try? response.map(Binom.BackendError.self, atKeyPath: "data", using: self.decoder)
                        let error = PMGeneralError(message: backendError?.error ?? PMessages.somethingWentWrong)
                        return seal.reject(error)
                    }
                    return seal.fulfill(installResponse.uuid.string)
                case .failure(let error):
                    return seal.reject(error)
                }
            }
        }
    }
    
    func updateSubscription(
        _ params: Binom.SubscriptionUpdateParameters,
        result: @escaping (Swift.Result<Void, Error>) -> Void = { _ in }
    ) {
        provider.request(.updateSubscription(params)) { (requestResult) in
            switch requestResult {
            case .success:
                return result(.success(()))
            case .failure(let error):
                return result(.failure(error))
            }
        }
    }
}
