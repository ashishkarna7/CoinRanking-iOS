//
//  MockNetworkManager.swift
//  CoinRankingTests
//
//  Created by Ashish Karna on 23/02/2025.
//

import Foundation
import Combine

final class MockNetworkManager: NetworkManagerProtocol {
    var mockData: Data?
    var mockError: NetworkError?

    func request<T: Decodable>(_ api: CoinRankingAPI) -> AnyPublisher<T, NetworkError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let data = mockData else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedObject)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.decodingError(error)).eraseToAnyPublisher()
        }
    }
}
