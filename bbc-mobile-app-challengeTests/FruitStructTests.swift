//
//  FruitStructTests.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 7/1/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import XCTest
@testable import bbc_mobile_app_challenge

class FruitStructTests: XCTestCase {
    
    func testFruitStruct() {
        
        let fruitStruct = FruitStruct(fruitType: "apple", price: 500, weight: 780)
        
        XCTAssertEqual(fruitStruct.fruitType, "apple", "Fruit type should be apple")
        XCTAssertEqual(fruitStruct.price, 500, "Fruit price should be 500")
        XCTAssertEqual(fruitStruct.weight, 780, "Fruit weight should be 780")
        
    }
    
}
