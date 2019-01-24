//
//  CurrencyListController.swift
//  Konvertor
//
//  Created by Олександр Потапов on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import UIKit
class CurrencyListController {
    var currencyList: [Currency] {
        var permanentList = [Currency]()
        for curName in currencyEnum.allCases {
            permanentList.append(Currency(abbriviation: curName.rawValue, currencyName: currencyDict[curName.rawValue]!))
        }
        return permanentList
    }
   
}
