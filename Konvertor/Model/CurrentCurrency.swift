//
//  CurrentCurrency.swift
//  Konvertor
//
//  Created by mrsSwift on 23.01.2019.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import Foundation
import UIKit

struct CurrentExchangeRate {
    let timestamp: Double
    let base: String
    let date: NSDate
    let rates: Dictionary<String, Double> // ["UAH": 27.896]
}


extension CurrentExchangeRate: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let timestamp = JSON["timestamp"] as? Double,
              let base = JSON["base"] as? String
        else {
            return nil
        }
        
        self.timestamp = timestamp
        self.base  = base
        self.date  = NSDate(timeIntervalSince1970: self.timestamp)
        self.rates = JSON["rates"] as? Dictionary<String, Double> ?? [:]
    }
}

