//
//  FruitExtension.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

extension Fruit {
    
    static func save(object: FruitStruct, context: NSManagedObjectContext) {
        
        let fruit = Fruit(context: context)
        fruit.fruitType = object.fruitType
        fruit.price = object.price ?? 0
        fruit.weight = object.weight ?? 0
        
    }
    
    static func get(context: NSManagedObjectContext) -> [Fruit]? {
        
        let fetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fruitType", ascending: true)]
        return try? context.fetch(fetchRequest)
        
    }
    
    static func deleteAll(context: NSManagedObjectContext) {
        
        guard let objects = Fruit.get(context: context) else { return }
        for obj in objects {
            context.delete(obj)
        }
        
    }
    
}
