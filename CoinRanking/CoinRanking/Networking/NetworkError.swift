//
//  NetworkError.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(statusCode: Int, data: Data?)
    case decodingError(Error)
    case noInternetConnection  // Specific error
    case unknown

    // Add a localizedDescription for better error presentation
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
