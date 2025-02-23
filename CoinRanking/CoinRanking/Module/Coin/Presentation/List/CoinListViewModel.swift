//
//  RankListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

/// View model class responsible for managing cryptocurrency list data and user interactions
class CoinListViewModel: BaseListViewModel {
    // MARK: - Properties
    /// Manager object handling cryptocurrency data operations
    private let manager: CoinManagerProtocol
    /// Current filter type applied to the coin list
    private(set) var filterType: CoinFilterType
    
    /// Previous filter tag value for tracking filter changes
    private var previousFilterTag: Int = 0
    /// Current filter tag value
    private var currentFilterTag: Int = 0
    
    // MARK: - Initialization
    /// Initializes the view model with a manager and filter type
    /// - Parameters:
    ///   - manager: The manager object conforming to CoinRankManagerProtocol
    ///   - type: The initial filter type to apply
    init(manager: CoinManagerProtocol, type: CoinFilterType) {
        self.manager = manager
        self.filterType = type
        super.init()
        
        setupBindings()
    }
    
    // MARK: - Private Methods
    /// Sets up Combine bindings for last page and empty content states
    private func setupBindings() {
        manager.isLastPageTriggered
            .sink { [weak self] value in
                self?.isLastPage = value
            }
            .store(in: &cancellables)
        
        if filterType == .favorite {
            manager.isEmptyContent
                .sink { [weak self] value in
                    self?.showNoResultOption.send(value)
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Data Loading
    /// Fetches coin list data based on the loading type
    /// - Parameter type: Type of content loading (initial or pagination)
    override func getItemList(type: ContentLoadingType) {
        // Handle favorite filter type separately
        if filterType == .favorite {
            viewState.send(.idle)
            didContentFetched.send(true)
            return
        }
        
        // Prevent duplicate fetches for initial load
        if type == .initial && manager.getFetchStatus(filterType: filterType) {
            viewState.send(.idle)
            didContentFetched.send(true)
            return
        }
        
        showLoading(type: type)
        guard shouldExecuteManager else { return }
        
        handleCompletion(
            manager.executeCoinList(
                page: currentPageOffset,
                filterType: filterType
            )
        )
    }
    
    // MARK: - TableView Data Source
    /// Returns the number of sections in the table view
    /// - Returns: Number of sections (always 1)
    override func getNumberOfSection() -> Int {
        return 1
    }
    
    /// Returns the number of rows in a given section
    /// - Parameter section: The section index
    /// - Returns: Number of items in the section
    override func getNumberOfRow(at section: Int) -> Int {
        return manager.getCoinItems(for: filterType).count
    }
    
    /// Retrieves the coin item view model for a specific index path
    /// - Parameter indexPath: The index path of the requested item
    /// - Returns: CoinListItemViewModel if exists, nil otherwise
    func getItem(from indexPath: IndexPath) -> CoinListItemViewModel? {
        let items = manager.getCoinItems(for: filterType)
        guard indexPath.row < items.count else { return nil }
        return items[indexPath.row]
    }
    
    // MARK: - Data Management
    /// Clears all cached data
    override func resetData() {
        manager.removeData()
    }
    
    /// Toggles the favorite status of a coin at the specified index path
    /// - Parameter indexPath: The index path of the coin to toggle
    func toggleFavorite(at indexPath: IndexPath) {
        guard let item = getItem(from: indexPath) else { return }
        
        if item.isFavorite {
            manager.removeFavorite(uuid: item.uuid)
        } else {
            manager.addFavorite(uuid: item.uuid)
        }
    }
    
    /// Applies a new filter to the coin list
    /// - Parameter tag: The tag value representing the filter type
    func applyFilter(tag: Int) {
        previousFilterTag = currentFilterTag
        currentFilterTag = tag
        
        guard currentFilterTag != previousFilterTag else { return }
        
        filterType = CoinFilterType(rawValue: tag) ?? .all
        isLastPage = manager.getLastPageStatus(filterType: filterType)
        getItemList(type: .initial)
    }
    
    /// Retrieves detailed information for a specific coin
    /// - Parameter uuid: The unique identifier of the coin
    /// - Returns: A view model containing the coin's detailed information
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel {
        return manager.getCoinDetail(uuid: uuid)
    }
    
    func getManager() -> CoinManagerProtocol {
        return manager
    }
}
