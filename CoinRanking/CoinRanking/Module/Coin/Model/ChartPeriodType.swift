//
//  ChartPeriodType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

enum ChartPeriodType: Int {
    case day = 0
    case week = 1
    case month = 2
    case year = 3
    
    var value: String {
        switch self {
        case .day: return "1D"
        case .week: return "1W"
        case .month: return "1M"
        default: return "1Y"
        }
    }
}
