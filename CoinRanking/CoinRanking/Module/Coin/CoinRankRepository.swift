//
//  RankRepository.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation
import Combine

class CoinRankRepository: CoinRankRepositoryProtocol {
    
    private var cancellables: Set<AnyCancellable>
    private var networkService: NetworkMangerProtocol
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        self.networkService = NetworkManager()
    }
    
    func fetchCoinList(page: Int, limit: Int, filterType: FilterType) -> AnyPublisher<CoinResponse, NetworkError> {
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
    
    func fetchCoinDetail(uuid:String) -> AnyPublisher<CoinDetailResponse, NetworkError> { 
        let param = CoinDetailParameter(uuid: uuid)
        return self.networkService.request(CoinRankingAPI.getCoinDetail(param))
    }
}

struct CoinListParameters: Encodable {
    let limit: Int?
    let offset: Int?
    let orderBy: String?
}

struct CoinDetailParameter: Encodable {
    let uuid: String
}
