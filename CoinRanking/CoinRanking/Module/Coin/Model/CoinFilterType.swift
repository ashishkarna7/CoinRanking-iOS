//
//  FilterType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

/// Enum representing different types of filters that can be applied to cryptocurrency lists
enum CoinFilterType: Int {
    /// Shows all cryptocurrencies without filtering
    case all = 0
    /// Filters cryptocurrencies by highest price
    case highestprice = 1
    /// Filters cryptocurrencies by 24-hour performance
    case performance24h = 2
    /// Shows only favorite/bookmarked cryptocurrencies
    case favorite = 3

    /// Returns the localized display string for the filter type
    var value: String {
        switch self {
        case .all: return LocalizedKeys.all.value
        case .highestprice: return LocalizedKeys.highestPrice.value
        case .performance24h: return LocalizedKeys.performance24h.value
        default: return LocalizedKeys.favorite.value
        }
    }
}
