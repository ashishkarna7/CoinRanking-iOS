//
//  RankRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

protocol RankRepositoryProtocol {
    func fetchRankList(page: Int, limit: Int, filterType: FilterType) -> AnyPublisher<CoinResponse, NetworkError>
}
