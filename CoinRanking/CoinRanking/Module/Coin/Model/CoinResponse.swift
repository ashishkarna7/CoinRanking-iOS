//
//  CoinResponse.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

struct CoinResponse: Decodable {
    let data: CoinData
}

struct CoinData: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable {
    let uuid: String
    let name: String
    let symbol: String
    let price: String
    let change: String
    let iconUrl: String
    let color: String
    let sparkline: [String?]
    let allTimeHigh: AllTimeHigh?
    let marketCap: String?
    let priceAt: Int?
    
}

struct CoinDetailResponse: Decodable {
    let data: CoinDetailData
}

struct CoinDetailData: Decodable {
    let coin: Coin
}


struct AllTimeHigh: Decodable {
    let price: String
    
}
