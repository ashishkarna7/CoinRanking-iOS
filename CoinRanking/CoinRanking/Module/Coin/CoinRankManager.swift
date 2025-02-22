//
//  RankManager.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

class CoinRankManager: CoinRankManagerProtocol {
    
    private var repository: CoinRankRepositoryProtocol
    
    var coinListDataSource: [CoinFilterType: [CoinListItemViewModel]] = [:]
    var coinDetailDataSource: [String: CoinDetailItemViewModel] = [:]
    
    private var fetchStatus: [CoinFilterType: Bool] = [:]
    private var lastPageStatus: [CoinFilterType: Bool] = [:]
    
    private var itemsPerPage: Int = 20
    private var maxLimit: Int = 100
    
    var isLastPageTriggered = PassthroughSubject<Bool, Never>()
    var isEmptyContent = PassthroughSubject<Bool, Never>()
    
    init(repository: any CoinRankRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeCoinList(page: Int, filterType: CoinFilterType) -> AnyPublisher<[CoinListItemViewModel], ErrorResponse> {
        return repository.fetchCoinList(page: page,
                                        limit: itemsPerPage,
                                        filterType: filterType)
            .map { [weak self] response -> [CoinListItemViewModel] in
                guard let self = self else { return [] }
                fetchStatus[filterType] = true
                let coins = response.data.coins
                let itemViewModels = coins.map { CoinListItemViewModel(coin: $0) }
 
                if coins.count < self.itemsPerPage {
                    self.lastPageStatus[filterType] = true
                    self.isLastPageTriggered.send(true)
                }
                
                // Get already fetched items and their UUIDs
                let previouslyFetchedItems = self.coinListDataSource.flatMap({ $0.value })

                // Preserve favorite status for existing items
                for item in itemViewModels {
                    if let foundItem = previouslyFetchedItems.first(where: { $0.uuid == item.uuid }) {
                        item.setFavorite(value: foundItem.isFavorite)
                    }
                }

                // Add only unique items to the data source
                if page == 0 {
                    self.coinListDataSource[filterType] = itemViewModels
                } else {
                    self.coinListDataSource[filterType]?.append(contentsOf: itemViewModels)
                }
                
                let totalItems = self.coinListDataSource[filterType] ?? []
                
                if totalItems.count >= self.maxLimit {
                    self.lastPageStatus[filterType] = true
                    self.isLastPageTriggered.send(true)
                }

                return totalItems
            }
            .mapError { error in
                ErrorResponse(type: LocalizedKeys.networkError.value, message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func executeCoinDetail(uuid: String, period: ChartPeriodType) -> AnyPublisher<CoinDetailItemViewModel?, ErrorResponse> {
        return repository.fetchCoinDetail(uuid: uuid, period: period)
            .map({ [weak self]  response in
                guard let self = self else { return nil}
                let itemViewModel = CoinDetailItemViewModel(coin: response.data.coin, timePeriod: period)
                self.coinDetailDataSource[uuid] = itemViewModel
                return self.coinDetailDataSource[uuid]
            }).mapError({ error in
                ErrorResponse(type: LocalizedKeys.networkError.value, message: error.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    func getCoinItems(for filterType: CoinFilterType) -> [CoinListItemViewModel] {
        let items =  coinListDataSource[filterType] ?? []
        if items.isEmpty {
            self.isEmptyContent.send(true)
        }
        return items
    }
    
    func addFavorite(uuid: String) {
        coinListDataSource.forEach { key, items in
            guard key != .favorite else { return }
            
            for item in items where item.uuid == uuid {
                item.addFavorite()
            }
        }
        
        // Collect updated favorites while maintaining the original order
        var seen = Set<String>() // Track UUIDs to remove duplicates
        let filteredItems = coinListDataSource
            .filter { $0.key != .favorite }
            .flatMap { $0.value }
            .filter { $0.isFavorite && seen.insert($0.uuid).inserted }

        coinListDataSource[.favorite] = filteredItems
    }

    
    func removeFavorite(uuid: String) {
        coinListDataSource.forEach { key, items in
            guard key != .favorite else { return }
            
            for item in items where item.uuid == uuid {
                item.removeFavorite()
            }
        }
        
        // Collect updated favorites while maintaining the original order
        var seen = Set<String>() // Track UUIDs to remove duplicates
        let filteredItems = coinListDataSource
            .filter { $0.key != .favorite }
            .flatMap { $0.value }
            .filter { $0.isFavorite && seen.insert($0.uuid).inserted }

        coinListDataSource[.favorite] = filteredItems
    }

    
    func removeData() {
        self.coinListDataSource.removeAll()
        self.fetchStatus.removeAll()
    }
    
    func getFetchStatus(filterType: CoinFilterType) -> Bool {
        return fetchStatus[filterType] ?? false
    }
    
    func getLastPageStatus(filterType: CoinFilterType) -> Bool {
        return lastPageStatus[filterType] ?? false
    }
    
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel {
        if let item = coinDetailDataSource[uuid] {
            return item
        } else {
            if let item = coinListDataSource.flatMap({$0.value}).first(where: {$0.uuid == uuid}) {
                coinDetailDataSource[uuid] = CoinDetailItemViewModel(vm: item)
            }
        }
        return coinDetailDataSource[uuid]!
    }
}
