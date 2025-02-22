//
//  RankListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

class RankListViewModel: BaseListViewModel {
    
    var manager: RankManagerProtocol
    
    init(manager: RankManagerProtocol) {
        self.manager = manager
        super.init()
        self.itemsPerPage = 20
        self.maxLimit = 100
    }
    
    override func getItemList(type: ContentLoadingType) {
        showLoading(type: type)
        guard shouldExecuteManager else {return}
        if type == .pagination {
            print("pagination")
        }
        handleCompletion(manager.executeRankList(page: self.currentPageOffset, limit: self.itemsPerPage))
    }
}
