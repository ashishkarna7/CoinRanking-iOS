//
//  NetworkError.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

// MARK: - NetworkError

/// Represents possible network-related errors that can occur during API requests
enum NetworkError: Error, Equatable {
    /// The URL provided for the request was invalid
    case invalidURL
    
    /// The request failed with a specific HTTP status code and optional response data
    /// - Parameters:
    ///   - statusCode: The HTTP status code received
    ///   - data: Optional response data from the failed request
    case requestFailed(statusCode: Int, data: Data?)
    
    /// An error occurred while decoding the response data
    /// - Parameter error: The underlying decoding error
    case decodingError(Error)
    
    /// No internet connection is available
    case noInternetConnection
    
    /// An unknown or unexpected error occurred
    case unknown

    /// A human-readable description of the error
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let statusCode, _):
            return "Request failed with status code \(statusCode)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .noInternetConnection:
            return "No internet connection"
        case .unknown:
            return "Unknown error"
        }
    }
    
    /// Compares two NetworkError instances for equality
    /// - Parameters:
    ///   - lhs: Left-hand side NetworkError to compare
    ///   - rhs: Right-hand side NetworkError to compare
    /// - Returns: True if the errors are equal, false otherwise
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.unknown, .unknown):
            return true
        case (.requestFailed(let statusCode1, _), .requestFailed(let statusCode2, _)):
            return statusCode1 == statusCode2
        case (.decodingError(let error1), .decodingError(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
