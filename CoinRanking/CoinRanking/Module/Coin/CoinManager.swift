//
//  RankManager.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

/// Manager class responsible for handling cryptocurrency data operations and state management
///
/// This class serves as the central manager for cryptocurrency data, handling:
/// - Fetching and caching of coin lists and details
/// - Managing pagination and data source updates
/// - Handling favorite coin operations
/// - Tracking fetch and pagination states
///
/// The manager uses a repository pattern for data access and implements the CoinRankManagerProtocol.
class CoinManager: CoinManagerProtocol {
    
    // MARK: - Properties
    /// Repository for handling network requests and data fetching
    private let repository: CoinRepositoryProtocol
    
    /// Data source for coin lists, organized by filter type
    /// Key: Filter type (all, highestprice, performance24h, favorite)
    /// Value: Array of view models for that filter
    private var coinListDataSource: [CoinFilterType: [CoinListItemViewModel]] = [:]
    
    /// Cache for coin detail view models
    /// Key: Coin UUID
    /// Value: Detailed view model for that coin
    private var coinDetailDataSource: [String: CoinDetailItemViewModel] = [:]
    
    /// Tracks fetch status for each filter type
    /// Key: Filter type
    /// Value: Boolean indicating if initial fetch is complete
    private var fetchStatus: [CoinFilterType: Bool] = [:]
    
    /// Tracks last page status for each filter type
    /// Key: Filter type
    /// Value: Boolean indicating if last page is reached
    private var lastPageStatus: [CoinFilterType: Bool] = [:]
    
    /// Number of items to fetch per page
    private let itemsPerPage: Int = 20
    
    /// Maximum number of items that can be fetched
    private let maxLimit: Int = 100
    
    /// Publisher for notifying when last page is reached
    var isLastPageTriggered = PassthroughSubject<Bool, Never>()
    
    /// Publisher for notifying when content is empty
    var isEmptyContent = PassthroughSubject<Bool, Never>()
    
    // MARK: - Initialization
    /// Initializes the manager with a repository
    /// - Parameter repository: The repository conforming to CoinRankRepositoryProtocol
    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    /// Fetches a list of coins based on the given page and filter type
    /// - Parameters:
    ///   - page: The page number to fetch
    ///   - filterType: The type of filter to apply
    /// - Returns: A publisher containing an array of coin list view models or an error
    func executeCoinList(page: Int, filterType: CoinFilterType) -> AnyPublisher<[CoinListItemViewModel], ErrorResponse> {
        repository.fetchCoinList(
            page: page,
            limit: itemsPerPage,
            filterType: filterType
        )
        .map { [weak self] response -> [CoinListItemViewModel] in
            guard let self = self else { return [] }
            
            self.fetchStatus[filterType] = true
            let itemViewModels = response.data.coins.map { CoinListItemViewModel(coin: $0) }
            
            self.handlePagination(coins: response.data.coins, filterType: filterType)
            self.updateDataSource(with: itemViewModels, page: page, filterType: filterType)
            
            return self.coinListDataSource[filterType] ?? []
        }
        .mapError { error in
            ErrorResponse(
                type: LocalizedKeys.networkError.value,
                message: error.localizedDescription
            )
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetches detailed information for a specific coin
    /// - Parameters:
    ///   - uuid: The unique identifier of the coin
    ///   - period: The time period for chart data
    /// - Returns: A publisher containing the coin detail view model or an error
    func executeCoinDetail(uuid: String, period: ChartPeriodType) -> AnyPublisher<CoinDetailItemViewModel?, ErrorResponse> {
        repository.fetchCoinDetail(uuid: uuid, period: period)
            .map { [weak self] response -> CoinDetailItemViewModel? in
                guard let self = self else { return nil }
                
                let itemViewModel = CoinDetailItemViewModel(
                    coin: response.data.coin,
                    timePeriod: period
                )
                self.coinDetailDataSource[uuid] = itemViewModel
                return itemViewModel
            }
            .mapError { error in
                ErrorResponse(
                    type: LocalizedKeys.networkError.value,
                    message: error.localizedDescription
                )
            }
            .eraseToAnyPublisher()
    }
    
    /// Retrieves coin items for a specific filter type
    /// - Parameter filterType: The type of filter to apply
    /// - Returns: An array of coin list view models
    func getCoinItems(for filterType: CoinFilterType) -> [CoinListItemViewModel] {
        let items = coinListDataSource[filterType] ?? []
        if items.isEmpty {
            isEmptyContent.send(items.isEmpty)
        }
        return items
    }
    
    /// Adds a coin to favorites
    /// - Parameter uuid: The unique identifier of the coin
    func addFavorite(uuid: String) {
        updateFavoriteStatus(uuid: uuid, isFavorite: true)
        updateFavoritesList()
    }
    
    /// Removes a coin from favorites
    /// - Parameter uuid: The unique identifier of the coin
    func removeFavorite(uuid: String) {
        updateFavoriteStatus(uuid: uuid, isFavorite: false)
        updateFavoritesList()
    }
    
    /// Clears all cached data
    func removeData() {
        coinListDataSource.removeAll()
        fetchStatus.removeAll()
    }
    
    /// Checks if initial fetch is complete for a filter type
    /// - Parameter filterType: The filter type to check
    /// - Returns: Boolean indicating fetch status
    func getFetchStatus(filterType: CoinFilterType) -> Bool {
        fetchStatus[filterType] ?? false
    }
    
    /// Checks if last page is reached for a filter type
    /// - Parameter filterType: The filter type to check
    /// - Returns: Boolean indicating last page status
    func getLastPageStatus(filterType: CoinFilterType) -> Bool {
        lastPageStatus[filterType] ?? false
    }
    
    /// Retrieves detailed information for a specific coin
    /// - Parameter uuid: The unique identifier of the coin
    /// - Returns: A view model containing the coin's detailed information
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel {
        if let cachedDetail = coinDetailDataSource[uuid] {
            return cachedDetail
        }
        
        if let listItem = coinListDataSource.values
            .flatMap({ $0 })
            .first(where: { $0.uuid == uuid }) {
            let detailViewModel = CoinDetailItemViewModel(vm: listItem)
            coinDetailDataSource[uuid] = detailViewModel
            return detailViewModel
        }
        
        fatalError("Coin detail not found for UUID: \(uuid)")
    }
    
    // MARK: - Private Methods
    /// Handles pagination logic based on fetched coins
    /// - Parameters:
    ///   - coins: Array of fetched coins
    ///   - filterType: The filter type being paginated
    private func handlePagination(coins: [Coin], filterType: CoinFilterType) {
        let isLastPage = coins.count < itemsPerPage
        lastPageStatus[filterType] = isLastPage
        isLastPageTriggered.send(isLastPage)
        
        let totalItems = (coinListDataSource[filterType]?.count ?? 0) + coins.count
        if totalItems >= maxLimit {
            lastPageStatus[filterType] = true
            isLastPageTriggered.send(true)
        }
    }
    
    /// Updates the data source with new items
    /// - Parameters:
    ///   - newItems: Array of new coin list view models
    ///   - page: The page number being updated
    ///   - filterType: The filter type being updated
    private func updateDataSource(with newItems: [CoinListItemViewModel], page: Int, filterType: CoinFilterType) {
        let existingItems = coinListDataSource.flatMap { $0.value }
        
        // Preserve favorite status
        for item in newItems {
            if let existing = existingItems.first(where: { $0.uuid == item.uuid }) {
                item.setFavorite(value: existing.isFavorite)
            }
        }
        
        if page == 0 {
            coinListDataSource[filterType] = newItems
        } else {
            coinListDataSource[filterType]?.append(contentsOf: newItems)
        }
    }
    
    /// Updates the favorite status for a specific coin
    /// - Parameters:
    ///   - uuid: The unique identifier of the coin
    ///   - isFavorite: The new favorite status
    private func updateFavoriteStatus(uuid: String, isFavorite: Bool) {
        coinListDataSource.forEach { key, items in
            guard key != .favorite else { return }
            
            items.first(where: { $0.uuid == uuid })?
                .setFavorite(value: isFavorite)
        }
    }
    
    /// Updates the favorites list based on current favorite statuses
    private func updateFavoritesList() {
        var seen = Set<String>()
        let favorites = coinListDataSource
            .filter { $0.key != .favorite }
            .flatMap { $0.value }
            .filter { $0.isFavorite && seen.insert($0.uuid).inserted }
        
        coinListDataSource[.favorite] = favorites
    }
}
