//
//  CoinRankRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

protocol CoinRankRepositoryProtocol {
    func fetchCoinList(page: Int, limit: Int, filterType: CoinFilterType) -> AnyPublisher<CoinResponse, NetworkError>
    func fetchCoinDetail(uuid:String, period: ChartPeriodType) -> AnyPublisher<CoinDetailResponse, NetworkError>
}
