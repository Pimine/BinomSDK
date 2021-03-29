//  Tests.swift
//  Copyright (c) 2020 Pimine All Rights Reserved
//
//  Unauthorized copying of this file, via any medium is strictly prohibited
//  Proprietary and confidential
//
//  Created by Den Andreychuk <denis.andrei4uk@yandex.ua> on 17.12.2020

import XCTest
import BinomSDK

class Tests: XCTestCase {

    func testExample() throws {
        BinomManager.shared.setup(with: BinomManager.Configuration(staticToken: "dfdhfgfeHy-Jds-tfe637tr7yger", uuid: "2536421", app: 5, host: URL(string: "http://backend.twtrack.site/api/v2")!))
        let expectation = self.expectation(description: "Offer")
        BinomManager.shared.retrieveOffer { (result) in
            print(result)
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testPerformanceExample() throws {
       
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
