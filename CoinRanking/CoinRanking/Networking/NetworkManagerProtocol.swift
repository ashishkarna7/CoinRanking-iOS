//
//  NetworkManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Combine


// MARK: - NetworkService Protocol

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ api: CoinRankingAPI) -> AnyPublisher<T, NetworkError>
}
