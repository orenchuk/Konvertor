//
//  Converter.swift
//  Konvertor
//
//  Created by Sasha Kryklyvets on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

class Converter {
    
    static func convert(inputCurrency: String, amount: Double, outputCurrency: String, currency: CurrentExchangeRate) -> String {
        let pricePerDollarForInputCurrency = currency.rates[inputCurrency]!
        let fullPriceInDollarForInputCurrency = amount / pricePerDollarForInputCurrency
        let pricePerDollarForOutputCurrency = currency.rates[outputCurrency]!
        let result = fullPriceInDollarForInputCurrency * pricePerDollarForOutputCurrency
        return String(format: "%.2f", result)
        }
}



