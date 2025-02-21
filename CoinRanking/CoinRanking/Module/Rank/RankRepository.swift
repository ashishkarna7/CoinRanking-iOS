//
//  RankRepository.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation
import Combine

class RankRepository: RankRepositoryProtocol {
    
    private var cancellables: Set<AnyCancellable>
    private var networkService: NetworkMangerProtocol
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        self.networkService = NetworkManager()
    }
    
    func fetchRankList(page: Int) -> AnyPublisher<CoinResponse, NetworkError> {
        let param = CoinListParameters(limit: 10, offset: page)
        return self.networkService.request(CoinRankingAPI.getCoinList(param))
    }
}
