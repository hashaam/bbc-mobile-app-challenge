//
//  DateFormatterManager.swift
//  bbc-mobile-app-challenge
//
//  Created by Hashaam Siddiq on 7/1/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    var formatter = DateFormatter()
    
    init() {
        
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
        self.formatter.dateFormat = "yyyy MM dd"
        
    }
    
}
