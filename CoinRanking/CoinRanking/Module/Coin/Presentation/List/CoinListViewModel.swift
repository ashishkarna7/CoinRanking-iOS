//
//  RankListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

class CoinListViewModel: BaseListViewModel {
    
    private(set) var manager: CoinRankManagerProtocol
    
    private(set) var filterType: FilterType
    
    private var previousSelectedTag: Int = 0
    private var currrentSelectedTag: Int = 0
    private var fetchStatus: [FilterType: Bool] = [:]
    
    init(manager: CoinRankManagerProtocol, type: FilterType) {
        self.filterType = type
        self.manager = manager
        super.init()
        
        manager.isLastPageTriggered.sink(receiveValue: { [weak self] value in
            guard let self = self else {return}
            self.isLastPage = value
        }).store(in: &cancellables)
        
        if self.filterType == .favorite {
            manager.isEmptyContent.sink(receiveValue: { [weak self] value in
                guard let self = self else {return}
                self.showNoResultOption.send(value)
            }).store(in: &cancellables)
        }
    }
    
    override func getItemList(type: ContentLoadingType) {
        
        if currentPageOffset > 1 {
            return
        }
        if filterType == .favorite {
            didContentFetched.send(true)
            return
        }
        
        if type == .initial, manager.getFetchStatus(filterType: filterType) {
            didContentFetched.send(true)
            return
        }
        
        showLoading(type: type)
        guard shouldExecuteManager else {return}
        if type == .pagination {
            print("pagination")
        }
        handleCompletion(manager.executeCoinList(page: self.currentPageOffset, filterType: filterType))
    }
    
    override func getNumberOfSection() -> Int {
        return 1
    }
    
    override func getNumberOfRow(at section: Int) -> Int {
        return manager.getCoinItems(for: filterType).count
    }
    
    func getItem(from indexPath: IndexPath) -> CoinListItemViewModel {
        return manager.getCoinItems(for: filterType)[indexPath.row]
    }
    
    override func resetData() {
        fetchStatus.removeAll()
        manager.removeData()
    }
    
    func toggleFavorite(at indexPath: IndexPath) {
        let item = getItem(from: indexPath)
        if item.isFavorite {
            manager.removeFavorite(uuid: item.uuid)
        } else {
            manager.addFavorite(uuid: item.uuid)
        }
    }
    
    func applyFilter(tag: Int) {
        self.previousSelectedTag = self.currrentSelectedTag
        self.currrentSelectedTag = tag
        if self.currrentSelectedTag != self.previousSelectedTag {
            switch tag {
            case FilterType.all.rawValue: filterType = .all
            case FilterType.price.rawValue: filterType = .price
            case FilterType.volume.rawValue: filterType = .volume
            default: filterType = .favorite
            }
            
            // update lastpage boolean
            self.isLastPage = manager.getLastPageStatus(filterType: filterType) 
            getItemList(type: .initial)
        }
    }
    
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel {
        return manager.getCoinDetail(uuid: uuid)
    }
}
