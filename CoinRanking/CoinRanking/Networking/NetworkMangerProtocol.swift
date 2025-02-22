//
//  NetworkMangerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Combine


// MARK: - NetworkService Protocol

protocol NetworkMangerProtocol {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, NetworkError>
}
