//
//  LocalizedKeys.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

protocol Localizable {
    var value:String {get}
    func value(with args: [CVarArg]) -> String
}

enum LocalizedKeys: String, Localizable {
    func value(with args: [CVarArg]) -> String {
        return String(format: value, arguments: args)
    }
    
    var value: String {
        let tableName = "Localizable"
        let finalString = NSLocalizedString(self.rawValue,
                                            tableName: tableName,
                                            bundle: Bundle.main,
                                            value: NSLocalizedString(self.rawValue, comment: ""),
                                            comment: "")
        return finalString
    }
    
    case noResultFound = "no_result_found"
    case networkError = "network_error"
    case day
    case week
    case month
    case year
    case all
    case highestPrice = "highest_price"
    case performance24h = "performance_24h"
    case price
    case coin
    case change
    case favorite
    case coinList = "coin_list"
    case priceChart = "price_chart"
    case statistics
    case date
    case marketCap = "market_cap"
    case priceAt = "price_at"
    case allTimeHigh = "all_time_high"
}
