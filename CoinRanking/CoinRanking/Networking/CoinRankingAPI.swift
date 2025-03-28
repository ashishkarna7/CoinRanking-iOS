//
//  CoinRankingTarget.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation


enum CoinRankingAPI: TargetType {
    
    case getCoinList(CoinListParameters)
    case getCoinDetail(String, CoinDetailParameter)

    var baseURL: String { "https://api.coinranking.com/v2/" }
    
    var path: String {
        switch self {
        case .getCoinList: return "coins"
        case .getCoinDetail(let uuid, _): return "coin/\(uuid)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var parameters: Encodable? {
        switch self {
        case .getCoinList(let param):
            return param
        case .getCoinDetail(_, let param):
            return param // Path parameters should not be in query/body
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getCoinList:
            return .queryString
        case .getCoinDetail:
            return .queryString // No request body, but can still support query params if needed
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authentication: Authentication { .none}

    func modifyRequest(_ request: inout URLRequest) {
        if let value = BuildConfigManager.shared.value(for: .API_KEY) as? String, !value.isEmpty {
            request.addValue(value,
                             forHTTPHeaderField: "x-access-token")
        }
    }
}

