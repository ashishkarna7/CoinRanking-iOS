//
//  NetworkManger.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

// MARK: - Network Service

final class NetworkManager: NetworkManagerProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ api: CoinRankingAPI) -> AnyPublisher<T, NetworkError> {

        guard let url = URL(string: api.baseURL + api.path) else {
            return Fail<T, NetworkError>(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        request.allHTTPHeaderFields = api.headers

        if let parameters = api.parameters {
            if let encodedData = api.parameterEncoding.encode(parameters) {
                switch api.method {
                case .get:
                    if api.parameterEncoding == .queryString {
                        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        components?.percentEncodedQuery = String(data: encodedData, encoding: .utf8)
                        request.url = components?.url
                    }
                default:
                    request.httpBody = encodedData
                    if api.parameterEncoding == .jsonBody {
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                }
            }
        }

        api.modifyRequest(&request) // Allow customization before auth
        request = api.authentication.apply(to: request)

        #if DEBUG
           NetworkLogger.logRequest(request)
        #endif
        return session.dataTaskPublisher(for: request)
                .handleEvents(receiveOutput: { data, response in
                    #if DEBUG
                    NetworkLogger.logResponse(response, data: data)
                    #endif
                })
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
                            return NetworkError.noInternetConnection
                        }
                        return NetworkError.requestFailed(statusCode: urlError.code.rawValue, data: nil)
                    } else {
                        return NetworkError.unknown
                    }
                }
                .eraseToAnyPublisher()
    }
}
