//
//  NetworkManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Combine


// MARK: - NetworkService Protocol

/// Protocol defining the interface for network service operations
protocol NetworkManagerProtocol {
    /// Makes a network request for a given API endpoint and decodes the response
    /// - Parameter api: The API endpoint to request, conforming to CoinRankingAPI
    /// - Returns: A publisher that emits the decoded response of type T or a NetworkError
    /// - Note: The response type T must conform to Decodable
    func request<T: Decodable>(_ api: CoinRankingAPI) -> AnyPublisher<T, NetworkError>
}
