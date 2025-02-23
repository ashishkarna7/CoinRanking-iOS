//
//  LocalizedKeys.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

/// Protocol defining requirements for localizable strings
protocol Localizable {
    /// The localized string value
    var value: String { get }
    
    /// Returns localized string with format arguments
    /// - Parameter args: Variable arguments to insert into format string
    /// - Returns: Formatted localized string
    func value(with args: [CVarArg]) -> String
}

/// Enum containing all localization keys used in the app
enum LocalizedKeys: String, Localizable {
    /// Returns localized string with format arguments inserted
    /// - Parameter args: Variable arguments to insert into format string
    /// - Returns: Formatted localized string
    func value(with args: [CVarArg]) -> String {
        return String(format: value, arguments: args)
    }
    
    /// The localized string value for this key
    var value: String {
        let tableName = "Localizable"
        let finalString = NSLocalizedString(self.rawValue,
                                            tableName: tableName,
                                            bundle: Bundle.main,
                                            value: NSLocalizedString(self.rawValue, comment: ""),
                                            comment: "")
        return finalString
    }
    
    /// No search results found message
    case noResultFound = "no_result_found"
    
    /// Network error message
    case networkError = "network_error"
    
    /// Day time period
    case day
    
    /// Week time period  
    case week
    
    /// Month time period
    case month
    
    /// Year time period
    case year
    
    /// All time period
    case all
    
    /// Highest price label
    case highestPrice = "highest_price"
    
    /// 24 hour performance label
    case performance24h = "performance_24h"
    
    /// Price label
    case price
    
    /// Coin label
    case coin
    
    /// Price change label
    case change
    
    /// Favorite label
    case favorite
    
    /// Coin list title
    case coinList = "coin_list"
    
    /// Price chart title
    case priceChart = "price_chart"
    
    /// Statistics label
    case statistics
    
    /// Date label
    case date
    
    /// Market cap label
    case marketCap = "market_cap"
    
    /// Price at specific time label
    case priceAt = "price_at"
    
    /// All time high price label
    case allTimeHigh = "all_time_high"
}
