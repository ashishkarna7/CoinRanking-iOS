//
//  DefaultNetworkService.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

// MARK: - NetworkService Protocol

protocol NetworkService {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, NetworkError>
}

// MARK: - Network Service

final class DefaultNetworkService: NetworkService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, NetworkError> {

        guard let url = URL(string: target.baseURL + target.path) else {
            return Fail<T, NetworkError>(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers

        if let parameters = target.parameters {
            if let encodedData = target.parameterEncoding.encode(parameters) {
                switch target.method {
                case .get:
                    if target.parameterEncoding == .queryString {
                        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        components?.percentEncodedQuery = String(data: encodedData, encoding: .utf8)
                        request.url = components?.url
                    }
                default:
                    request.httpBody = encodedData
                    if target.parameterEncoding == .jsonBody {
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                }
            }
        }

        target.modifyRequest(&request) // Allow customization before auth
        request = target.authentication.apply(to: request)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }

                if 200..<300 ~= httpResponse.statusCode {
                    return data
                } else {
                    throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: data)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError(error)
                } else if let urlError = error as? URLError {
                    if urlError.code == .notConnectedToInternet {
                        return NetworkError.noInternetConnection // More specific error
                    }
                    return NetworkError.requestFailed(statusCode: urlError.code.rawValue, data: nil) // Include URL error code
                } else {
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Example Usage (More Realistic)

struct Coin: Decodable, Equatable { // Added Equatable for testing
    let uuid: String
    let name: String
    let symbol: String
}

struct CoinListParameters: Encodable {
    let limit: Int?
    let offset: Int?
    let base: String?
}



// Usage Example in ViewModel or other

let networkService = DefaultNetworkService()

let cancellable = networkService.request(CoinRankingTarget.getCoinList(CoinListParameters(limit: 10, offset: 0, base: "USD")))
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)") // Use localizedDescription
        case .finished:
            print("Finished")
        }
    }, receiveValue: { (coins: [Coin]) in
        print("Coins: \(coins)")
    })

// Store cancellable to keep the subscription alive
