//
//  ErrorResponse.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

class ErrorResponse: Codable, Error {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case  message
    }

    init(message: String) {
        self.message = message
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
