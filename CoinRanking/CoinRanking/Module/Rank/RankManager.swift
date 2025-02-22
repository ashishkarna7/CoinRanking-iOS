//
//  RankManager.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

enum FilterType: Int {
    case all = 0
    case price = 1
    case volume = 2
    case favorite = 3

    var value: String {
        switch self {
        case .all: return "All"
        case .price: return "Highest Price"
        case .volume: return "Best 24h"
        default: return "Favorite"
        }
    }
}

class RankManager: RankManagerProtocol {
    
    private var repository: RankRepositoryProtocol
    
    var dataSource: [FilterType: [RankListItemViewModel]] = [:]
    private var fetchStatus: [FilterType: Bool] = [:]
    private var lastPageStatus: [FilterType: Bool] = [:]
    
    private var itemsPerPage: Int = 2
    private var maxLimit: Int = 10
    
    var isLastPageTriggered = PassthroughSubject<Bool, Never>()
    var isEmptyContent = PassthroughSubject<Bool, Never>()
    
    init(repository: any RankRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeRankList(page: Int, filterType: FilterType) -> AnyPublisher<[RankListItemViewModel], ErrorResponse> {
        return repository.fetchRankList(page: page,
                                        limit: itemsPerPage,
                                        filterType: filterType)
            .map { [weak self] response -> [RankListItemViewModel] in
                guard let self = self else { return [] }
                fetchStatus[filterType] = true
                let coins = response.data.coins
                let itemViewModels = coins.map { RankListItemViewModel(coin: $0) }
 
                if coins.count < self.itemsPerPage {
                    self.lastPageStatus[filterType] = true
                    self.isLastPageTriggered.send(true)
                }
                
                // Get already fetched items and their UUIDs
                let previouslyFetchedItems = self.dataSource.flatMap({ $0.value })
                let existingUUIDs = Set(previouslyFetchedItems.map { $0.uuid })

                // Preserve favorite status for existing items
                for item in itemViewModels {
                    if let foundItem = previouslyFetchedItems.first(where: { $0.uuid == item.uuid }) {
                        item.setFavorite(value: foundItem.isFavorite)
                    }
                }

                // Add only unique items to the data source
                if page == 0 {
                    self.dataSource[filterType] = itemViewModels
                } else {
                    let newItems = itemViewModels.filter { !existingUUIDs.contains($0.uuid) }
                    self.dataSource[filterType]?.append(contentsOf: newItems)
                }
                
                let totalItems = self.dataSource[filterType] ?? []
                
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
    
    func getCoinItems(for filterType: FilterType) -> [RankListItemViewModel] {
        let items =  dataSource[filterType] ?? []
        if items.isEmpty {
            self.isEmptyContent.send(true)
        }
        return items
    }
    
    func addFavorite(uuid: String) {
        let items = dataSource.flatMap({$0.value}).filter({$0.uuid == uuid})
        if !items.isEmpty {
            items.forEach({$0.addFavorite()})
        }
        let filteredItems = dataSource.filter({$0.key != .favorite}).flatMap({$0.value}).filter({$0.isFavorite})
        dataSource[.favorite] = filteredItems
    }
    
    func removeFavorite(uuid: String) {
        let items = dataSource.flatMap({$0.value}).filter({$0.uuid == uuid})
        if !items.isEmpty {
            items.forEach({$0.removeFavorite()})
        }
        let filteredItems = dataSource.filter({$0.key != .favorite}).flatMap({$0.value}).filter({$0.isFavorite})
        dataSource[.favorite] = filteredItems
    }
    
    func removeData() {
        self.dataSource.removeAll()
        self.fetchStatus.removeAll()
    }
    
    func getFetchStatus(filterType: FilterType) -> Bool {
        return fetchStatus[filterType] ?? false
    }
    
    func getLastPageStatus(filterType: FilterType) -> Bool {
        return lastPageStatus[filterType] ?? false
    }
}
