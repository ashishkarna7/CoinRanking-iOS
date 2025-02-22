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
    
    func fetchCoinList(page: Int, limit: Int, filterType: CoinFilterType) -> AnyPublisher<CoinResponse, NetworkError> {
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
    
    func fetchCoinDetail(uuid:String, period: ChartPeriodType) -> AnyPublisher<CoinDetailResponse, NetworkError> {
        var timePeriod = ""
        switch period {
        case .day:
            timePeriod = "24h"
        case .week:
            timePeriod = "7d"
        case .month:
            timePeriod = "30d"
        case .year:
            timePeriod = "1y"
        }
        let param = CoinDetailParameter(timePeriod: timePeriod)
        return self.networkService.request(CoinRankingAPI.getCoinDetail(uuid, param))
    }
}

struct CoinListParameters: Encodable {
    let limit: Int?
    let offset: Int?
    let orderBy: String?
}

struct CoinDetailParameter: Encodable {
    let timePeriod: String?
}
