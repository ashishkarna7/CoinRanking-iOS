//
//  CoinRankRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

protocol CoinRankRepositoryProtocol {
    func fetchCoinList(page: Int, limit: Int, filterType: FilterType) -> AnyPublisher<CoinResponse, NetworkError>
    func fetchCoinDetail(uuid:String) -> AnyPublisher<CoinDetailResponse, NetworkError>
}
