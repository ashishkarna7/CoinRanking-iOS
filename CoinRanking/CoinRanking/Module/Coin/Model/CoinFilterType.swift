//
//  FilterType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

enum CoinFilterType: Int {
    case all = 0
    case price = 1
    case volume = 2
    case favorite = 3

    var value: String {
        switch self {
        case .all: return "All"
        case .price: return "Highest Price"
        case .volume: return "Best 24h"
        default: return "Favorite"
        }
    }
}
