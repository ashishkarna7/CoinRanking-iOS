//
//  CoinDetailItemViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

class CoinDetailItemViewModel: CoinListItemViewModel {
    private(set) var chartData: [CoinPricePoint] = []
    private(set) var chartBackgroundColor: String?
    private(set) var marketCap: String?
    private(set) var priceAt: String?
    private(set) var allTimeHigh: String?
    
    init(coin: Coin, timePeriod: ChartPeriodType) {
        super.init(coin: coin)
        let sparkline = coin.sparkline.compactMap({$0})
        chartData = self.mapSparklineData(sparkline: sparkline, timePeriod: timePeriod)
        self.chartBackgroundColor = coin.color
        
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
    
    override init(vm: CoinListItemViewModel) {
        super.init(vm: vm)
    }
    
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


struct CoinPricePoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
