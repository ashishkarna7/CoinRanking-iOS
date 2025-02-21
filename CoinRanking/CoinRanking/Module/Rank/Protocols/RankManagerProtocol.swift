//
//  RankManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

protocol RankManagerProtocol {
    func executeRankList(page: Int) -> AnyPublisher<[RankListItemViewModel], ErrorResponse>
}
