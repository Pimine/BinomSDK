//  BinomManager.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 10.08.2020

import Moya
import UIKit
import Pimine

public final class BinomManager {
    
    public enum Configuration {
        case host(URL)
        case app(Int)
    }
    
    // MARK: - Properties
    
    private(set) public static var host: URL!
    
    private(set) public static var app: Int!
    
    private static let provider = BinomProvider()
    
    private static var screens: [String] = []
    
    @UserDefaultsBacked(key: Keys.uuid)
    public static var uuid: Int?
    
    @UserDefaultsBacked(key: Keys.clickID)
    public static var clickID: String?
    
    @UserDefaultsBacked(key: Keys.coupon)
    public static var coupon: String?
    
    @UserDefaultsBacked(key: Keys.isCouponValid)
    public static var isCouponValid: Bool?
    
    // MARK: - Setup
    
    public static func configure(_ configuration: [Configuration]) {
        for config in configuration {
            switch config {
            case .host(let host):
                self.host = host
            case .app(let app):
                self.app = app
            }
        }
        trackInstall()
    }
    
    // MARK: - Methods
    
    public static func parsePasteboardContent() -> [String]? {
        guard
            let encodedData = UIPasteboard.general.string,
            let decodedData = Data(base64Encoded: encodedData),
            let content = String(data: decodedData, encoding: .utf8)
        else { return nil }
        
        let params = content.components(separatedBy: "//")
        guard params.count == 4 else { return nil }
        
        let clickID = params[1]
        let screenKeys = params[2]
        let coupon = params[3]
        
        self.clickID = clickID
        self.coupon = coupon
        self.screens = screenKeys.components(separatedBy: "|")
        
        return self.screens
    }
    
    public static func trackInstall(
        silently: Bool = true,
        result: @escaping (Result<Binom.InstallResponse, Error>) -> Void = { _ in }
    ) {
        var params: Binom.InstallParameters?
        if let coupon = coupon, let clickID = clickID, screens.count > 0  {
            params = Binom.InstallParameters(
                coupon: coupon,
                screen: screens.joined(separator: "|"),
                clickID: clickID
            )
        }
        
        provider.trackInstall(params) { (requestResult) in
            switch requestResult {
            case .success(let response):
                if !params.isNil {
                    self.uuid = response.uuid
                    self.isCouponValid = response.isCouponValid
                }
                return result(.success(response))
            case .failure(let error):
                if !silently { PMAlert.show(error: error) }
                return result(.failure(error))
            }
        }
    }
    
    public static func updateSubscription(
        to subscription: String,
        screenID: String,
        silently: Bool = true
    ) {
        guard
            let receiptDataURL = Bundle.main.appStoreReceiptURL,
            let receipt = try? Data(contentsOf: receiptDataURL).base64EncodedString(),
            let uuid = uuid
        else { return }
        
        let params = Binom.SubscriptionUpdateParameters(
            uuid: uuid,
            receipt: receipt,
            subscription: subscription,
            screenID: screenID,
            app: app
        )
        
        provider.updateSubscription(params) { (requestResult) in
            guard case .failure(let error) = requestResult, !silently else { return }
            PMAlert.show(error: error)
        }
    }
}
