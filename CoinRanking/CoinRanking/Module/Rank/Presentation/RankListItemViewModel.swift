//
//  CoinListItemViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

class RankListItemViewModel: ListItemViewModel {
    var uuid: String
    private(set) var name: String
    private(set) var price: String
    private(set) var change: String
    private(set) var iconUrl: URL?
    private(set) var isFavorite: Bool
    
    private(set) var isChangePositive: Bool
    
    init(coin: Coin) {
        uuid = coin.uuid
        name = coin.name
        if let value = Double(coin.price) {
            price = "$" + String(format: "%.2f", value)
        } else {
            price = ""
        }
        change = "\(coin.change)%"
        iconUrl = URL(string: coin.iconUrl) 
        isFavorite = false
        if let change = Double(coin.change), change < 0 {
            isChangePositive = false
        } else {
            isChangePositive = true
        }
    }
    
    func toggleFavorite() {
        self.isFavorite = !self.isFavorite
    }
}
