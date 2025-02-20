//
//  CoinRankingTarget.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation


enum CoinRankingTarget: TargetType {
    case getCoinList(CoinListParameters)

    var baseURL: String { "https://api.coinranking.com/v2/" }
    var path: String { "coins" }
    var method: HTTPMethod { .get }
    var parameters: Encodable? {
        switch self {
        case .getCoinList(let params): return params
        }
    }
    var parameterEncoding: ParameterEncoding { .queryString }
    var headers: [String : String]? { nil }
    var authentication: Authentication { .none }

    func modifyRequest(_ request: inout URLRequest) {
        // Example: Add a custom header
        // request.addValue("API-Key", forHTTPHeaderField: "x-api-key")
    }
}

