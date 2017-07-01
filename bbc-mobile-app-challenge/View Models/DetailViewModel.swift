//
//  DetailViewModel.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation

class DetailViewModel {

    fileprivate let fruit: Fruit

    init(fruit: Fruit) {
        
        self.fruit = fruit
        
    }
    
}

extension DetailViewModel {
    
    var fruitType: String? {
        return fruit.fruitType
    }
    
    var fruitPrice: String {
        let priceInPence = fruit.price
        let priceInPounds = Float(priceInPence) / 100.0
        return String(format: "£%.2f / %dp", priceInPounds, priceInPence)
    }
    
    var fruitWeight: String {
        let weight = Float(fruit.weight) / 1000.0
        return String(format: "%.2fkg", weight)
    }
    
}
