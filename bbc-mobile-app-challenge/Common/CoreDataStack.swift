//
//  CoreDataStack.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer!
    var persistentStoreDescriptions: [NSPersistentStoreDescription]?
    
    var readyHandler: () -> Void
    
    init(readyHandler: @escaping ()->Void) {
        
        self.readyHandler = readyHandler
        
    }
    
    func initializeCoreDataStack() {
        
        container = NSPersistentContainer(name: "model")
        if let descriptions = persistentStoreDescriptions {
            container.persistentStoreDescriptions = descriptions
        }
        container.loadPersistentStores { [weak self] (storeDescription: NSPersistentStoreDescription, error: Error?) in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Failed to load store")
                print("Unresolved error \(error.localizedDescription)\nAttempted to create store")
                abort()
            }
            
            DispatchQueue.main.async {
                strongSelf.readyHandler()
            }
            
        }
        
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        let containerViewContext = self.container.viewContext
        containerViewContext.automaticallyMergesChangesFromParent = true
        return containerViewContext
    }()
    
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    func saveContext() {
        
        if !container.viewContext.hasChanges { return }
        
        container.viewContext.perform { [weak self] in
            
            guard let strongSelf = self else { return }
            
            do {
                
                try strongSelf.container.viewContext.save()
                
            } catch let error {
                
                print("Error saving context: \(error.localizedDescription)")
                abort()
                
            }
            
        }
        
    }
    
}
