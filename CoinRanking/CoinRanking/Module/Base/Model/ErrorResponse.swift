//
//  ErrorResponse.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

class ErrorResponse: Codable, Error {
    var type: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case type, message
    }

    init(type: String, message: String) {
        self.type = type
        self.message = message
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
