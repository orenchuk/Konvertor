//
//  APICurrencyManager.swift
//  Konvertor
//
//  Created by mrsSwift on 23.01.2019.
//  Copyright © 2019 Perchiki. All rights reserved.
//

import Foundation

enum CurrencyExchangeType: FinalURLPoint {
    case Current(apiKey: String)
    
    var baseURL: URL {
        return URL(string: "https://openexchangerates.org")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey):
            return "/api/latest.json?app_id=\(apiKey)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}


final class APICurrencyManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let apiKey: String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentCurrencyExchangeRateWith(completionHandler: @escaping (APIResult<CurrentExchangeRate>) -> Void) {
        let request = CurrencyExchangeType.Current(apiKey: self.apiKey).request
        
        fetch(request: request, parse: { (json) -> CurrentExchangeRate? in
            // Prints json struct
            // print(json)

            return CurrentExchangeRate(JSON: json)
        }, completionHandler: completionHandler)
    }
}
