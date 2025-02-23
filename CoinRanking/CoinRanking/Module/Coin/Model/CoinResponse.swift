//
//  CoinResponse.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

/// Response model containing cryptocurrency data
struct CoinResponse: Decodable {
    /// The main data container
    let data: CoinData
}

/// Container for coin list data
struct CoinData: Decodable {
    /// Array of coin information
    let coins: [Coin]
}

/// Model representing a single cryptocurrency
struct Coin: Decodable {
    /// Unique identifier for the coin
    let uuid: String
    /// Name of the cryptocurrency
    let name: String
    /// Trading symbol/ticker of the cryptocurrency
    let symbol: String
    /// Current price of the coin
    let price: String
    /// Price change percentage
    let change: String
    /// URL to the coin's icon/logo
    let iconUrl: String
    /// Brand color associated with the coin
    let color: String?
    /// Historical price data points for sparkline chart
    let sparkline: [String?]
    /// All-time high price information
    let allTimeHigh: AllTimeHigh?
    /// Market capitalization value
    let marketCap: String?
    /// Unix timestamp of price data
    let priceAt: Int?
}

/// Response model for detailed coin information
struct CoinDetailResponse: Decodable {
    /// The main data container
    let data: CoinDetailData
}

/// Container for detailed coin data
struct CoinDetailData: Decodable {
    /// Detailed coin information
    let coin: Coin
}

/// Model representing all-time high price data
struct AllTimeHigh: Decodable {
    /// The highest price ever reached
    let price: String
}
