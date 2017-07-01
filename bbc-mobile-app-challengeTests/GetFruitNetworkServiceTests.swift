//
//  GetFruitNetworkServiceTests.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 7/1/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import XCTest
import CoreData
@testable import bbc_mobile_app_challenge

class GetFruitNetworkServiceTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var networkService: GetFruitNetworkService!
    
    override func setUp() {
        super.setUp()
        
        let exp = expectation(description: "\(#function)\(#line)")
        
        let coreDataStack = CoreDataStack(readyHandler: {
            exp.fulfill()
        })
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        coreDataStack.persistentStoreDescriptions = [description]
        
        coreDataStack.initializeCoreDataStack()
        
        self.coreDataStack = coreDataStack
        
        waitForExpectations(timeout: 40, handler: nil)
        
    }
    
    func testGettingFruitFromNetwork() {
        
        let exp = expectation(description: "testGettingFruitFromNetwork")
        
        networkService = GetFruitNetworkService(coreDataStack: coreDataStack, completionHandler: { [weak self] (result: NetworkServiceResultType) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success:
                
                guard let fruits = Fruit.get(context: strongSelf.coreDataStack.viewContext) else {
                    exp.fulfill()
                    return
                }
                
                guard let firstFruit = fruits.first else {
                    exp.fulfill()
                    return
                }
                
                XCTAssertEqual(firstFruit.fruitType, "apple", "Fruit type should be apple")
                XCTAssertEqual(firstFruit.price, 149, "Fruit price should be 149")
                XCTAssertEqual(firstFruit.weight, 120, "Fruit weight should be 120")
                
                
            case .failure(let error):
                
                XCTAssertNotNil(error, "Error should not be nil")
                
            }
            
            exp.fulfill()
            
        })
        networkService.start()
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
}
