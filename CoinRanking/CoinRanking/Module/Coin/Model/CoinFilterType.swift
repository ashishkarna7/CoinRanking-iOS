//
//  FilterType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

enum CoinFilterType: Int {
    case all = 0
    case highestprice = 1
    case performance24h = 2
    case favorite = 3

    var value: String {
        switch self {
        case .all: return LocalizedKeys.all.value
        case .highestprice: return LocalizedKeys.highestPrice.value
        case .performance24h: return LocalizedKeys.performance24h.value
        default: return LocalizedKeys.favorite.value
        }
    }
}
