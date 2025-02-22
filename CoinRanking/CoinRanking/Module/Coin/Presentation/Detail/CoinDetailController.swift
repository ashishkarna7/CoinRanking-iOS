//
//  CoinDetailController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

class CoinDetailController: BaseController {
    
    var screenView: CoinDetailView {
        return baseView as! CoinDetailView
    }
    
    var viewModel: CoinDetailViewModel {
        return baseViewModel as! CoinDetailViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.coinDetail.name
        self.viewModel.fetchCoinDetail()
    }
    
    private func observeEvents() {
        viewModel.didLoadedContent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.populateView()
        }).store(in: &cancellables)
    }
    
    private func populateView() {
        
    }
}
