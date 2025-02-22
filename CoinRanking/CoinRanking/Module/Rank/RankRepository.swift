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
    
    func fetchRankList(page: Int, limit: Int, filterType: FilterType) -> AnyPublisher<CoinResponse, NetworkError> {
        var orderBy = ""
        switch filterType {
        case .all:
            orderBy = "marketCap"
        case .price:
            orderBy = "price"
        case .volume:
            orderBy = "24hVolume"
        default:
            break
        }
        let param = CoinListParameters(limit: limit, offset: page, orderBy: orderBy)
        return self.networkService.request(CoinRankingAPI.getCoinList(param))
    }
}

struct CoinListParameters: Encodable {
    let limit: Int?
    let offset: Int?
    let orderBy: String?
}
