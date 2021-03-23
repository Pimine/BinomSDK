//  BinomProvider.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 11.08.2020

import Moya
import PimineUtilities

final class BinomProvider {
    
    // MARK: - Properties
    
    private let provider = MoyaProvider<BinomAPI>()
    private let decoder = JSONDecoder()
    
    // MARK: - Tasks
    
    func trackInstall(
        _ params: Binom.InstallParameters?,
        result: @escaping (Result<Binom.InstallResponse, Error>) -> Void = { _ in }
    ) {
        provider.request(.trackInstall(params)) { (requestResult) in
            switch requestResult {
            case .success(let response):
                guard let installResponse = try? self.decoder.decode(Binom.InstallResponse.self, from: response.data) else {
                    let error = PMGeneralError(message: PMessages.somethingWentWrong)
                    return result(.failure(error))
                }
                return result(.success(installResponse))
            case .failure(let error):
                return result(.failure(error))
            }
        }
    }
    
    func updateSubscription(
        _ params: Binom.SubscriptionUpdateParameters,
        result: @escaping (Result<Void, Error>) -> Void = { _ in }
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
