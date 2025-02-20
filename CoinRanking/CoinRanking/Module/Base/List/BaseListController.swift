//
//  BaseListController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

class BaseListController: BaseController {
    
    var screenView: BaseListView {
        return baseView as! BaseListView
    }
    
    var viewModel: BaseListViewModel {
        return baseViewModel as! BaseListViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
