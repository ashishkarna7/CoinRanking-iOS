//
//  CoinDetailViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import Combine

/// View model class for displaying coin details
/// Handles fetching and updating coin information and chart data
class CoinDetailViewModel: BaseViewModel {
    
    /// Protocol for making coin ranking API calls
    private(set) var manager: CoinManagerProtocol
    
    /// Unique identifier for the coin
    private(set) var uuid: String
    
    /// View model containing coin details to display
    private(set) var coinDetail: CoinDetailItemViewModel
    
    /// Publisher that emits when content has been loaded
    private(set) var didLoadedContent = PassthroughSubject<Bool, Never>()
    
    /// Selected time period for chart data
    private(set) var period: ChartPeriodType = .day
    
    /// Initializes the view model with required dependencies
    /// - Parameters:
    ///   - manager: Protocol for making coin ranking API calls
    ///   - detail: Initial coin detail view model
    init(manager: CoinManagerProtocol, detail: CoinDetailItemViewModel) {
        self.manager = manager
        self.uuid = detail.uuid
        coinDetail = detail
        super.init()
    }
    
    /// Fetches updated coin details from the API
    /// Updates the view model and notifies observers on success
    func fetchCoinDetail() {
        
        manager.executeCoinDetail(uuid: self.uuid, period: period).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let failure):
                self.viewState.send(.error(failure))
            case .finished:
                break
            }
        }, receiveValue: { item in
            self.viewState.send(.idle)
            if let item = item {
                self.coinDetail = item
                self.didLoadedContent.send(true)
            }
        })
        .store(in: &cancellables)
    }
    
    /// Updates the selected time period and refreshes data
    /// - Parameter tag: Selected segment index corresponding to time period
    func applyFilter(tag: Int) {
        switch tag {
        case ChartPeriodType.day.rawValue: period = .day
        case ChartPeriodType.week.rawValue: period = .week
        case ChartPeriodType.month.rawValue: period = .month
        default: period = .year
        }
        self.viewState.send(.loading)
        fetchCoinDetail()
    }
}
