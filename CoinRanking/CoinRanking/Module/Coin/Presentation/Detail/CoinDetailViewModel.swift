//
//  CoinDetailViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import Combine

class CoinDetailViewModel: BaseViewModel {
    
    private(set) var  manager: CoinRankManagerProtocol
    private(set) var uuid: String
    private(set) var coinDetail: CoinDetailItemViewModel
    
    private(set) var didLoadedContent = PassthroughSubject<Bool, Never>()
    
    init(manager: CoinRankManagerProtocol, detail: CoinDetailItemViewModel) {
        self.manager = manager
        self.uuid = detail.uuid
        coinDetail = detail
        super.init()
    }
    
    func fetchCoinDetail() {
        manager.executeCoinDetail(uuid: self.uuid).sink(receiveCompletion: { completion in
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
}
