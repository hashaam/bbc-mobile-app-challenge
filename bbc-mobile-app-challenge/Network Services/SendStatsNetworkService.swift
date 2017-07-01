//
//  SendStatsNetworkService.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 7/1/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import Alamofire

enum StatType: String {
    case load = "load"
    case display = "display"
    case error = "error"
}

class SendStatsNetworkService {
    
    let statType: StatType
    let data: String
    
    var generatedUrlString: String {
        return "\(STATS_URL)?event=\(statType.rawValue)&data=\(data)"
    }
    
    init(statType: StatType, data: String) {
        self.statType = statType
        self.data = data
    }
    
    func start() {
        
        let _ = Alamofire.request(generatedUrlString)
        
    }
    
}
