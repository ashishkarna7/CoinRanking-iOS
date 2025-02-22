//
//  CoinDetailController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import UIKit

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
        self.screenView.config(vm: viewModel.coinDetail)
        observeEvents()
        screenView.segmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        viewModel.applyFilter(tag: sender.selectedSegmentIndex)
    }
    
    private func observeEvents() {
        viewModel.didLoadedContent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.screenView.config(vm: viewModel.coinDetail)
        }).store(in: &cancellables)
    }
}
