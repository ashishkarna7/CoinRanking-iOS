//
//  CoinDetailItemViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

/// View model class for displaying detailed coin information
/// Inherits from CoinListItemViewModel and adds additional chart and price data
class CoinDetailItemViewModel: CoinListItemViewModel {
    /// Array of price points for generating price chart
    private(set) var chartData: [CoinPricePoint] = []
    
    /// Background color for the chart in hex format
    private(set) var chartBackgroundColor: String?
    
    /// Formatted market cap value with appropriate suffix (K, M, B, T)
    private(set) var marketCap: String?
    
    /// Formatted price at a specific time with coin symbol
    private(set) var priceAt: String?
    
    /// Formatted all-time high price with $ symbol
    private(set) var allTimeHigh: String?
    
    /// Formatted symbol
    private(set) var symbol: String?
    
    /// Initializes view model with coin data and time period
    /// - Parameters:
    ///   - coin: The coin model containing raw data
    ///   - timePeriod: Time period for chart data (day, week, month, year)
    init(coin: Coin, timePeriod: ChartPeriodType) {
        super.init(coin: coin)
        let sparkline = coin.sparkline.compactMap({$0})
        chartData = self.mapSparklineData(sparkline: sparkline, timePeriod: timePeriod)
        self.chartBackgroundColor = coin.color
        self.symbol = coin.symbol
        if let marketCap = coin.marketCap {
            self.marketCap = formaLargeNumber(marketCap)
        }
        
        if let priceAt = coin.priceAt {
            self.priceAt = formaLargeNumber(String(priceAt)) + " " + coin.symbol
        }
        
        if let value = coin.allTimeHigh?.price {
            self.allTimeHigh = "$" + formaLargeNumber(value)
        }
    }
    
    /// Initializes view model from an existing CoinListItemViewModel
    /// - Parameter vm: The view model to copy
    override init(vm: CoinListItemViewModel) {
        super.init(vm: vm)
    }
    
    /// Maps sparkline price data to chart data points with dates
    /// - Parameters:
    ///   - sparkline: Array of price strings
    ///   - timePeriod: Time period for chart data
    /// - Returns: Array of CoinPricePoint objects with dates and prices
    func mapSparklineData(sparkline: [String], timePeriod: ChartPeriodType) -> [CoinPricePoint] {
        var pricePoints: [CoinPricePoint] = []
        let now = Date()
        
        // Determine the correct interval based on the timePeriod
        let interval: Int
        switch timePeriod {
        case .day:
            interval = 60 / max(sparkline.count / 24, 1)  // Approx hourly data
        case .week:
            interval = (24 * 60) / max(sparkline.count / 7, 1) // Approx every few hours
        case .month:
            interval = (24 * 60) / max(sparkline.count / 30, 1) // Approx daily
        case .year:
            interval = (24 * 60 * 30) / max(sparkline.count / 12, 1) // Approx monthly
        }
        
        // Map sparkline to date and price
        for (index, priceStr) in sparkline.enumerated() {
            if let price = Double(priceStr) {
                let date = Calendar.current.date(byAdding: .minute, value: -index * interval, to: now) ?? now
                pricePoints.append(CoinPricePoint(date: date, price: price))
            }
        }
        
        return pricePoints.reversed() // Ensure oldest data appears first
    }
    
    /// Formats large numbers with appropriate suffixes (K, M, B, T)
    /// - Parameter value: Number string to format
    /// - Returns: Formatted string with appropriate suffix
    func formaLargeNumber(_ value: String) -> String {
        guard let number = Double(value) else { return value }

        let trillion = 1_000_000_000_000.0
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        let thousand = 1_000.0

        if number >= trillion {
            return String(format: "%.2fT", number / trillion)
        } else if number >= billion {
            return String(format: "%.2fB", number / billion)
        } else if number >= million {
            return String(format: "%.2fM", number / million)
        } else if number >= thousand {
            return String(format: "%.2fK", number / thousand)
        } else {
            return String(format: "%.2f", number)
        }
    }

}

/// Model representing a single price point with date for charting
struct CoinPricePoint: Identifiable {
    /// Unique identifier for the price point
    let id = UUID()
    
    /// Date of the price point
    let date: Date
    
    /// Price value at the given date
    let price: Double
}
