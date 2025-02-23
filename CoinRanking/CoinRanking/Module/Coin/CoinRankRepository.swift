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
    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.cancellables = Set<AnyCancellable>()
        self.networkManager = networkManager
    }
    
    func fetchCoinList(page: Int, limit: Int, filterType: CoinFilterType) -> AnyPublisher<CoinResponse, NetworkError> {
        var orderBy = ""
        switch filterType {
        case .all:
            orderBy = "marketCap"
        case .highestprice:
            orderBy = "price"
        case .performance24h:
            orderBy = "24hVolume"
        default:
            break
        }
        let param = CoinListParameters(limit: limit, offset: page, orderBy: orderBy)
        return self.networkManager.request(.getCoinList(param))
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
        return self.networkManager.request(.getCoinDetail(uuid, param))
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
