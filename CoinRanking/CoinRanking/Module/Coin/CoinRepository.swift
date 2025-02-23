//
//  RankRepository.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation
import Combine

/// Repository class responsible for handling cryptocurrency data fetching operations
class CoinRepository: CoinRepositoryProtocol {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func fetchCoinList(page: Int, limit: Int, filterType: CoinFilterType) -> AnyPublisher<CoinResponse, NetworkError> {
        let orderBy = getOrderByParameter(for: filterType)
        let parameters = CoinListParameters(
            limit: limit,
            offset: page,
            orderBy: orderBy
        )
        return networkManager.request(.getCoinList(parameters))
    }
    
    func fetchCoinDetail(uuid: String, period: ChartPeriodType) -> AnyPublisher<CoinDetailResponse, NetworkError> {
        let timePeriod = getTimePeriodParameter(for: period)
        let parameters = CoinDetailParameter(timePeriod: timePeriod)
        return networkManager.request(.getCoinDetail(uuid, parameters))
    }
    
    // MARK: - Private Methods
    private func getOrderByParameter(for filterType: CoinFilterType) -> String {
        switch filterType {
        case .all:
            return "marketCap"
        case .highestprice:
            return "price"
        case .performance24h:
            return "24hVolume"
        case .favorite:
            return ""
        }
    }
    
    private func getTimePeriodParameter(for period: ChartPeriodType) -> String {
        switch period {
        case .day:     return "24h"
        case .week:    return "7d"
        case .month:   return "30d"
        case .year:    return "1y"
        }
    }
}

// MARK: - Request Parameters
/// Parameters for coin list API request
struct CoinListParameters: Encodable {
    let limit: Int?
    let offset: Int?
    let orderBy: String?
}

/// Parameters for coin detail API request
struct CoinDetailParameter: Encodable {
    let timePeriod: String?
}
