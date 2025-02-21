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
        
        viewModel.didContentFetched
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .sink(receiveValue: { _ in
                self.screenView.tableView.reloadData()
            })
            .store(in: &cancellables) // Store the subscription to retain it

    }
}
