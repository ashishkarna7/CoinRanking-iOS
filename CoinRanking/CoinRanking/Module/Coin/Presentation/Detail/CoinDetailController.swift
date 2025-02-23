//
//  CoinDetailController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import UIKit

/// Controller class for displaying detailed coin information
/// Handles configuring the view with coin data and responding to user interactions
class CoinDetailController: BaseController {
    
    /// The coin detail view managed by this controller
    var screenView: CoinDetailView {
        return baseView as! CoinDetailView
    }
    
    /// View model containing coin data and business logic
    var viewModel: CoinDetailViewModel {
        return baseViewModel as! CoinDetailViewModel
    }
    
    /// Configures the view when loaded
    /// - Sets up navigation title
    /// - Fetches initial coin data
    /// - Configures view with coin details
    /// - Sets up event observation and user interaction handling
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.coinDetail.name
        self.viewModel.fetchCoinDetail()
        self.screenView.config(vm: viewModel.coinDetail)
        observeEvents()
        screenView.segmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
    }
    
    /// Handles changes to the time period filter
    /// Updates the view model with the selected time period
    /// - Parameter sender: The segmented control that triggered the change
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        viewModel.applyFilter(tag: sender.selectedSegmentIndex)
    }
    
    /// Sets up observation of view model events
    /// Updates the view when new coin data is loaded
    private func observeEvents() {
        viewModel.didLoadedContent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.screenView.config(vm: viewModel.coinDetail)
        }).store(in: &cancellables)
    }
}
