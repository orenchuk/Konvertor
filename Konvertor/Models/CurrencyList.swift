//
//  CurrencyList.swift
//  Konvertor
//
//  Created by Олександр Потапов on 1/24/19.
//  Copyright © 2019 Perchiki. All rights reserved.
//

enum currencyEnum: String, CaseIterable {
    case USD
    case UAH
    case AUD
    case CAD
    case CHF
    case JPY
    case NZD
    case EUR
    case GBP
    case SEK
    case DKK
    case NOK
    case SGD
    case CZK
    case HKD
    case MXN
    case PLN
    case RUB
    case TRY
    case ZAR
    case CNH
    
    var description: String {
        switch self {
        case .USD: return "United States Dollar"
        case .UAH: return "Ukraine Hryvnia"
        case .AUD: return "Australian Dollar"
        case .CAD: return "Canadian Dollar"
        case .CHF: return "Swiss Franc"
        case .JPY: return "Japanese Yen"
        case .NZD: return "New Zealand Dollar"
        case .EUR: return "Euro"
        case .GBP: return "Pound"
        case .SEK: return "Swedish Krona"
        case .DKK: return "Danish Krone"
        case .NOK: return "Krona Norwegia"
        case .SGD: return "Singapore Dollar"
        case .CZK: return "Czech Koruna"
        case .HKD: return "Hong Kong Dollar"
        case .MXN: return "Mexican Peso"
        case .PLN: return "Zloty"
        case .RUB: return "Ruble"
        case .TRY: return "Turkish Lira"
        case .ZAR: return "Rand"
        case .CNH: return "Yuan"
        }
    }
}
