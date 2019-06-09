//
//  CurrencyListController.swift
//  Konvertor
//
//  Created by Олександр Потапов on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit

struct CurrencyListController {
    
    static let shared = CurrencyListController()
    
    var currencyList: [Currency] {
        var permanentList = [Currency]()
        for currency in currencyEnum.allCases {
            permanentList.append(Currency(abbriviation: currency.rawValue, currencyName: currency.description))
        }
        return permanentList
    }
}
