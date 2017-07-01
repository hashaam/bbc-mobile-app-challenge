//
//  AppDelegate.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreDataStack: CoreDataStack!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let coreDataStack = CoreDataStack(readyHandler: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let navigationController = strongSelf.window?.rootViewController as? UINavigationController else { return }
            guard let mainViewController = navigationController.topViewController as? MainViewController else { return }
            
            mainViewController.coreDataStack = strongSelf.coreDataStack

            
        })
        coreDataStack.initializeCoreDataStack()
        
        self.coreDataStack = coreDataStack
        
        return true
    }

}

