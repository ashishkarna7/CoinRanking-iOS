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
    }
    
    override func getItemList(type: ContentLoadingType) {
        showLoading(type: type)
        guard shouldExecuteManager else {return}
        handleCompletion(manager.executeRankList(page: self.currentPageOffset))
    }
}
