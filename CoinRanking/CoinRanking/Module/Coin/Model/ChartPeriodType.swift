//
//  ChartPeriodType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

/// Enum representing different time periods for cryptocurrency chart data
enum ChartPeriodType: Int {
    /// One day period
    case day = 0
    /// One week period 
    case week = 1
    /// One month period
    case month = 2
    /// One year period
    case year = 3
    
    /// Returns the localized display string for the time period
    var value: String {
        switch self {
        case .day: "1" + LocalizedKeys.day.value
        case .week: "1" + LocalizedKeys.week.value
        case .month: "1" + LocalizedKeys.month.value
        default: "1" + LocalizedKeys.year.value
        }
    }
}
