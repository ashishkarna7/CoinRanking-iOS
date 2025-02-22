//
//  RankListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

class CoinListViewModel: BaseListViewModel {
    
    private(set) var manager: CoinRankManagerProtocol
    
    private(set) var filterType: CoinFilterType
    
    private var previousSelectedTag: Int = 0
    private var currrentSelectedTag: Int = 0
    private var fetchStatus: [CoinFilterType: Bool] = [:]
    
    init(manager: CoinRankManagerProtocol, type: CoinFilterType) {
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
        
//        if currentPageOffset > 1 {
//            return
//        }
        if filterType == .favorite {
            self.viewState.send(.idle)
            didContentFetched.send(true)
            return
        }
        
        if type == .initial, manager.getFetchStatus(filterType: filterType) {
            self.viewState.send(.idle)
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
    
    func getItem(from indexPath: IndexPath) -> CoinListItemViewModel? {
        if indexPath.row < manager.getCoinItems(for: filterType).count {
            return manager.getCoinItems(for: filterType)[indexPath.row]
        }
        return nil
    }
    
    override func resetData() {
        fetchStatus.removeAll()
        manager.removeData()
    }
    
    func toggleFavorite(at indexPath: IndexPath) {
        guard let item = getItem(from: indexPath) else {return}
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
            case CoinFilterType.all.rawValue: filterType = .all
            case CoinFilterType.price.rawValue: filterType = .price
            case CoinFilterType.volume.rawValue: filterType = .volume
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
