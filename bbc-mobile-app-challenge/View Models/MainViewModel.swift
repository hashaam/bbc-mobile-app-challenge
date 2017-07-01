//
//  MainViewModel.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 6/30/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation

class MainViewModel {
    
    fileprivate var fruits: [Fruit]?
    
    private let coreDataStack: CoreDataStack
    private weak var delegate: ViewModelDelegate?
    
    private var networkService: GetFruitNetworkService!
    private var statsNetworkService: SendStatsNetworkService!
    
    private var startDate: Date!
    
    init(coreDataStack: CoreDataStack, delegate: ViewModelDelegate?) {
        
        self.coreDataStack = coreDataStack
        self.delegate = delegate
        
    }
    
    func loadData() {
        
        fruits = Fruit.get(context: coreDataStack.viewContext)
        
        if fruits?.count == 0 {
            fetchFruits()
        } else {
            delegate?.dataReady(success: true)
        }
        
    }
    
    func fetchFruits() {
        
        networkService = GetFruitNetworkService(coreDataStack: coreDataStack) { [weak self] (result: NetworkServiceResultType) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.sendStats(statType: .load, startDate: strongSelf.startDate)
            
            switch result {
                
            case .success:
                strongSelf.loadData()
            case .failure(let error):
                strongSelf.sendStats(statType: .error, data: error?.localizedDescription)
                strongSelf.delegate?.dataReady(success: false)
                
            }
            
        }
        
        startDate = Date()
        networkService.start()
        
    }
    
    func sendStats(statType: StatType, startDate: Date? = nil, data: String? = nil) {
        
        if let data = data, startDate == nil {
            
            // in case of error, data will be set and startDate is nil
            statsNetworkService = SendStatsNetworkService(statType: statType, data: data)
            statsNetworkService.start()
            
        }
        
        if let startDate = startDate, data == nil {
            
            // in case of time event, start date will be set and data will be nil
            let endDate = Date()
            
            let dateFormatter = DateFormatterManager.shared.formatter
            dateFormatter.dateFormat = "A"
            
            let startTimestamp = Int64(dateFormatter.string(from: startDate)) ?? 0
            let endTimestamp = Int64(dateFormatter.string(from: endDate)) ?? 0
            
            let difference = String(endTimestamp - startTimestamp)
            
            statsNetworkService = SendStatsNetworkService(statType: statType, data: difference)
            statsNetworkService.start()
            
        }
        
    }
        
}

extension MainViewModel {
    
    func numberOfRows() -> Int {
        return fruits?.count ?? 0
    }
    
    func fruitAt(index: Int) -> Fruit? {
        return fruits?[index]
    }
    
    func fruitTypeAt(index: Int) -> String? {
        return fruitAt(index: index)?.fruitType
    }
    
}
