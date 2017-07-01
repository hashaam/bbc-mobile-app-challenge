//
//  GetFruitNetworkService.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

enum NetworkServiceResultType {
    case success, failure(Error?)
}

class GetFruitNetworkService {
    
    let coreDataStack: CoreDataStack
    let completionHandler: (NetworkServiceResultType) -> Void
    
    init(coreDataStack: CoreDataStack, completionHandler: @escaping (NetworkServiceResultType) -> Void) {
        
        self.coreDataStack = coreDataStack
        self.completionHandler = completionHandler
        
    }
    
    func start() {
        
        Alamofire.request(DATA_URL).responseJSON { [weak self] (response: DataResponse<Any>) in
            
            guard let strongSelf = self else { return }
            
            if let error = response.error {
                DispatchQueue.main.async {
                    strongSelf.completionHandler(.failure(error))
                }
                return
            }
            
            if let json = response.result.value as? [String: Any], let fruits = json["fruit"] as? [[String: Any]] {
                
                strongSelf.coreDataStack.performBackgroundTask(block: { (context: NSManagedObjectContext) in
                    
                    Fruit.deleteAll(context: context)
                    
                    fruits.forEach { fruit in
                        
                        var fruitStruct = FruitStruct()
                        fruitStruct.fruitType = fruit["type"] as? String
                        fruitStruct.price = fruit["price"] as? Int16
                        fruitStruct.weight = fruit["weight"] as? Int16
                        
                        Fruit.save(object: fruitStruct, context: context)
                        
                    }
                    
                    try? context.save()
                    
                    DispatchQueue.main.async {
                        strongSelf.completionHandler(.success)
                    }
                    
                })
                
            } else {
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "Parse failed", code: 0, userInfo: nil)
                    strongSelf.completionHandler(.failure(error))
                }
                
            }
            
        }
        
    }

}
