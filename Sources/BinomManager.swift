//  BinomManager.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 10.08.2020

import Moya
import UIKit
import PromiseKit
import PimineUtilities

public final class BinomManager {
    
    public struct Configuration: Codable {
        
        public let staticToken: String
        public let uuid: String
        public let app: Int
        public let host: URL
        
        public init(staticToken: String, uuid: String, app: Int, host: URL) {
            self.staticToken = staticToken
            self.uuid = uuid
            self.app = app
            self.host = host
        }
    }
    
    // MARK: Properties
    
    private let provider = BinomProvider()
    
    internal var configuration: Configuration!
    
    private var token: Binom.Token!
    
    // MARK: Initialization
    
    public static let shared = BinomManager()
    
    private init() { }
    
    // MARK: API
    
    public func setup(with configuration: Configuration) {
        self.configuration = configuration
        NotificationCenter.default.addObserver(
            self, selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil
        )
    }
    
    public func retrieveOffer(result: @escaping (Swift.Result<[String], Error>) -> Void) {
        firstly {
            self.authenticate()
        }.then {
            self.trackInstall()
        }.done { screens in
            result(.success(screens))
        }.catch { error in
            result(.failure(error))
        }
    }
    
    public func updateSubscription(
        to subscription: String,
        screenID: String,
        silently: Bool = true
    ) {
        guard
            let receiptDataURL = Bundle.main.appStoreReceiptURL,
            let receipt = try? Data(contentsOf: receiptDataURL).base64EncodedString(),
            let token = token
        else { return }

        let params = Binom.SubscriptionUpdateParameters(
            uuid: configuration.uuid,
            receipt: receipt,
            subscription: subscription,
            screenID: screenID,
            app: configuration.app,
            token: token.token
        )

        provider.updateSubscription(params) { (requestResult) in
            guard case .failure(let error) = requestResult, !silently else { return }
            PMAlert.show(error: error)
        }
    }
    
    // MARK: Private
    
    @discardableResult
    private func authenticate() -> Promise<Void> {
        Promise { seal in
            provider.authenticate(.init(app: configuration.app, uuid: configuration.uuid, key: configuration.staticToken)).get { token in
                self.token = token
                seal.fulfill()
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func trackInstall() -> Promise<[String]> {
        Promise { seal in
            let params = retrieveClipboardContent() ?? Binom.InstallParameters(screen: nil, clickID: nil, token: token.token)
            provider.trackInstall(params).get { response in
                let screens = params.screen?.components(separatedBy: "|") ?? []
                return seal.fulfill(screens)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func retrieveClipboardContent() -> Binom.InstallParameters? {
        guard
            let encodedData = UIPasteboard.general.string,
            let decodedData = Data(base64Encoded: encodedData),
            let content = String(data: decodedData, encoding: .utf8)
        else { return nil }

        let params = content.components(separatedBy: "//")
        guard params.count == 4 else { return nil }

        let clickID = params[1]
        let screenKeys = params[2]
        
        return Binom.InstallParameters(screen: screenKeys, clickID: clickID, token: token.token)
    }
    
    // MARK: Events
    
    @objc private func willEnterForeground() {
        guard token.needRefresh else { return }
        authenticate()
    }
}
