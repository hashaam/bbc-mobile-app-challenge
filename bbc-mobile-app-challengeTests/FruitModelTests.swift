//
//  FruitModelTests.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 7/1/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import XCTest
import CoreData
@testable import bbc_mobile_app_challenge

class FruitModelTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        let exp = expectation(description: "\(#function)\(#line)")
        
        let coreDataStack = CoreDataStack(readyHandler: { [weak self] in

            guard let strongSelf = self else { return }
            
            strongSelf.coreDataStack.performBackgroundTask(block: { (context: NSManagedObjectContext) in
                
                var fruitStruct = FruitStruct()
                fruitStruct.fruitType = "mango"
                fruitStruct.price = 200
                fruitStruct.weight = 400
                
                Fruit.save(object: fruitStruct, context: context)
                
                try? context.save()
                
                exp.fulfill()
                
            })
            
        })
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        coreDataStack.persistentStoreDescriptions = [description]
        
        coreDataStack.initializeCoreDataStack()
        
        self.coreDataStack = coreDataStack
        
        waitForExpectations(timeout: 40, handler: nil)
        
    }
    
    func testGettingFruit() {
        
        let exp = expectation(description: "testGettingFruit")
        
        coreDataStack.performBackgroundTask { [weak self] (context: NSManagedObjectContext) in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                
                guard let fruits = Fruit.get(context: strongSelf.coreDataStack.viewContext) else {
                    exp.fulfill()
                    return
                }
                
                XCTAssertEqual(fruits.count, 1, "Fruits count should be 1")
                
                guard let lastFruit = fruits.last else {
                    exp.fulfill()
                    return
                }
                
                XCTAssertEqual(lastFruit.fruitType, "mango", "Fruit type should be mango")
                XCTAssertEqual(lastFruit.price, 200, "Fruit price should be 200")
                XCTAssertEqual(lastFruit.weight, 400, "Fruit weight should be 400")
                
                exp.fulfill()
                
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testDeletingFruit() {
        
        let exp = expectation(description: "testDeletingFruit")
        
        coreDataStack.performBackgroundTask { [weak self] (context: NSManagedObjectContext) in
            
            guard let strongSelf = self else { return }
            
            Fruit.deleteAll(context: context)
            
            try? context.save()
            
            DispatchQueue.main.async {
                
                guard let fruits = Fruit.get(context: strongSelf.coreDataStack.viewContext) else {
                    exp.fulfill()
                    return
                }
                
                XCTAssertEqual(fruits.count, 0, "Fruits count should be 0")
                
                exp.fulfill()
                
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
}
