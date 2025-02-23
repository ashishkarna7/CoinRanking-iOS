//
//  CoinRankRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

/// Protocol defining the interface for fetching cryptocurrency data from a repository
protocol CoinRepositoryProtocol {
    /// Fetches a paginated list of coins based on filter criteria
    /// - Parameters:
    ///   - page: The page number to fetch
    ///   - limit: The number of items per page
    ///   - filterType: The type of filter to apply to the coin list
    /// - Returns: A publisher that emits the coin response data or a network error
    func fetchCoinList(page: Int, limit: Int, filterType: CoinFilterType) -> AnyPublisher<CoinResponse, NetworkError>

    /// Fetches detailed information for a specific coin
    /// - Parameters:
    ///   - uuid: The unique identifier of the coin
    ///   - period: The time period for chart data
    /// - Returns: A publisher that emits the coin detail response data or a network error
    func fetchCoinDetail(uuid:String, period: ChartPeriodType) -> AnyPublisher<CoinDetailResponse, NetworkError>
}
