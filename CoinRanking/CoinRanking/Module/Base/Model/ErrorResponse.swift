//
//  ErrorResponse.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

class ErrorResponse: Codable, Error {
    var status: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status, message
    }

    init(status: String, message: String) {
        self.status = status
        self.message = message
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
