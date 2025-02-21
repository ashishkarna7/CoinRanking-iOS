//
//  RankListController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

class RankListController: BaseListController {
    
    override var viewModel: RankListViewModel {
        return baseViewModel as! RankListViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getItemList(type: .initial)
    }
    
}
