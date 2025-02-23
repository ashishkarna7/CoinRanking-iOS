//
//  NetworkManger.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

// MARK: - Network Service

/// A class responsible for handling network requests and responses
/// 
/// NetworkManager provides functionality to make HTTP requests, handle responses,
/// and decode data according to the CoinRanking API specifications.
final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Properties
    
    /// The URLSession used for making network requests
    private let session: URLSession
    
    /// The JSONDecoder used for decoding response data
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    
    /// Initializes a new NetworkManager instance
    /// - Parameters:
    ///   - session: The URLSession to use for network requests. Defaults to URLSession.shared
    ///   - decoder: The JSONDecoder to use for decoding responses. Defaults to a new JSONDecoder instance
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - NetworkManagerProtocol
    
    /// Makes a network request for the specified API endpoint
    /// - Parameter api: The API endpoint to request
    /// - Returns: A publisher that emits the decoded response or an error
    func request<T: Decodable>(_ api: CoinRankingAPI) -> AnyPublisher<T, NetworkError> {
        do {
            let request = try buildRequest(for: api)
            return executeRequest(request)
        } catch {
            return Fail(error: error as? NetworkError ?? .unknown).eraseToAnyPublisher()
        }
    }
    
    // MARK: - Private Methods
    
    /// Builds a URLRequest for the given API endpoint
    /// - Parameter api: The API endpoint to build a request for
    /// - Returns: A configured URLRequest
    /// - Throws: NetworkError if URL creation fails
    private func buildRequest(for api: CoinRankingAPI) throws -> URLRequest {
        guard let baseUrl = URL(string: api.baseURL + api.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = api.method.rawValue
        request.allHTTPHeaderFields = api.headers
        
        try configureRequestParameters(for: &request, with: api)
        
        // Allow API-specific customization before applying authentication
        api.modifyRequest(&request)
        return api.authentication.apply(to: request)
    }
    
    /// Configures request parameters based on the API specification
    /// - Parameters:
    ///   - request: The URLRequest to configure
    ///   - api: The API endpoint containing parameter information
    /// - Throws: NetworkError if parameter configuration fails
    private func configureRequestParameters(for request: inout URLRequest, with api: CoinRankingAPI) throws {
        guard let parameters = api.parameters,
              let encodedData = api.parameterEncoding.encode(parameters) else {
            return
        }
        
        switch (api.method, api.parameterEncoding) {
        case (.get, .queryString):
            try appendQueryParameters(encodedData, to: &request)
        case (_, .jsonBody):
            appendJsonBody(encodedData, to: &request)
        default:
            request.httpBody = encodedData
        }
    }
    
    /// Appends query parameters to the URL of a request
    /// - Parameters:
    ///   - encodedData: The encoded parameter data
    ///   - request: The URLRequest to modify
    /// - Throws: NetworkError if URL manipulation fails
    private func appendQueryParameters(_ encodedData: Data, to request: inout URLRequest) throws {
        guard let url = request.url,
              let query = String(data: encodedData, encoding: .utf8),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        components.percentEncodedQuery = query
        request.url = components.url
    }
    
    /// Appends JSON data to the body of a request
    /// - Parameters:
    ///   - encodedData: The encoded JSON data
    ///   - request: The URLRequest to modify
    private func appendJsonBody(_ encodedData: Data, to request: inout URLRequest) {
        request.httpBody = encodedData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    /// Executes a network request and processes the response
    /// - Parameter request: The URLRequest to execute
    /// - Returns: A publisher that emits the decoded response or an error
    private func executeRequest<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> {
        #if DEBUG
        NetworkLogger.logRequest(request)
        #endif
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { [weak self] data, response in
                self?.logResponseIfNeeded(response, data: data)
            })
            .tryMap { data, response in
                try self.validateResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError(handleError)
            .eraseToAnyPublisher()
    }
    
    /// Validates the HTTP response
    /// - Parameters:
    ///   - data: The response data
    ///   - response: The URLResponse to validate
    /// - Returns: The validated response data
    /// - Throws: NetworkError if validation fails
    private func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: data)
        }
        
        return data
    }
    
    /// Maps various error types to NetworkError
    /// - Parameter error: The error to handle
    /// - Returns: A NetworkError representing the error
    private func handleError(_ error: Error) -> NetworkError {
        switch error {
        case let networkError as NetworkError:
            return networkError
        case is DecodingError:
            return .decodingError(error)
        case let urlError as URLError:
            return urlError.code == .notConnectedToInternet
                ? .noInternetConnection
                : .requestFailed(statusCode: urlError.code.rawValue, data: nil)
        default:
            return .unknown
        }
    }
    
    /// Logs the network response if in debug mode
    /// - Parameters:
    ///   - response: The URLResponse to log
    ///   - data: The response data to log
    private func logResponseIfNeeded(_ response: URLResponse, data: Data) {
        #if DEBUG
        NetworkLogger.logResponse(response, data: data)
        #endif
    }
}
