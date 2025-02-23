//
//  RankManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

/// Protocol defining the interface for managing cryptocurrency data and operations
protocol CoinManagerProtocol {
    /// Fetches a paginated list of coins based on filter type
    /// - Parameters:
    ///   - page: The page number to fetch
    ///   - filterType: The type of filter to apply to the coin list
    /// - Returns: A publisher that emits an array of coin view models or an error
    func executeCoinList(page: Int, filterType: CoinFilterType) -> AnyPublisher<[CoinListItemViewModel], ErrorResponse>

    /// Fetches detailed information for a specific coin
    /// - Parameters:
    ///   - uuid: The unique identifier of the coin
    ///   - period: The time period for chart data
    /// - Returns: A publisher that emits the coin detail view model or an error
    func executeCoinDetail(uuid: String, period: ChartPeriodType) -> AnyPublisher<CoinDetailItemViewModel?, ErrorResponse>
    
    /// Subject that emits when the last page of results is reached
    var isLastPageTriggered: PassthroughSubject<Bool, Never> { get set }
    
    /// Subject that emits when the content list becomes empty
    var isEmptyContent: PassthroughSubject<Bool, Never> { get set }
    
    /// Retrieves cached coin items for a specific filter type
    /// - Parameter filterType: The type of filter to apply
    /// - Returns: An array of coin view models
    func getCoinItems(for filterType: CoinFilterType) -> [CoinListItemViewModel]
    
    /// Adds a coin to favorites
    /// - Parameter uuid: The unique identifier of the coin
    func addFavorite(uuid: String)
    
    /// Removes a coin from favorites
    /// - Parameter uuid: The unique identifier of the coin
    func removeFavorite(uuid: String)
    
    /// Clears all cached data
    func removeData()
    
    /// Checks if data is currently being fetched for a filter type
    /// - Parameter filterType: The type of filter to check
    /// - Returns: True if data is being fetched, false otherwise
    func getFetchStatus(filterType: CoinFilterType) -> Bool
    
    /// Checks if the last page has been reached for a filter type
    /// - Parameter filterType: The type of filter to check
    /// - Returns: True if last page reached, false otherwise
    func getLastPageStatus(filterType: CoinFilterType) -> Bool
    
    /// Retrieves detailed information for a specific coin
    /// - Parameter uuid: The unique identifier of the coin
    /// - Returns: A view model containing the coin's detailed information
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel
}
