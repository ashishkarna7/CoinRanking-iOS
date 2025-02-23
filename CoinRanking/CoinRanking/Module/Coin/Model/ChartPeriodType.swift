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
        case .day: "1" + LocalizedKeys.day.value
        case .week: "1" + LocalizedKeys.week.value
        case .month: "1" + LocalizedKeys.month.value
        default: "1" + LocalizedKeys.year.value
        }
    }
}
