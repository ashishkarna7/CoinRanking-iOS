//
//  CoinListItemViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation
import UIKit

class RankListItemViewModel: ListItemViewModel {
    var uuid: String
    private(set) var name: String
    private(set) var price: String
    private(set) var change: String
    private(set) var iconUrl: URL?
    private var isFavorite: Bool
    private(set) var backgroundColor: UIColor
    
    init(coin: Coin) {
        uuid = coin.uuid
        name = coin.name
        price = "$\(coin.price)"
        change = "\(coin.change)%"
        iconUrl = URL(string: coin.iconUrl) 
        isFavorite = false
        backgroundColor = .white
    }
    
    func toggleFavorite() {
        self.isFavorite = !self.isFavorite
        self.backgroundColor = isFavorite ? .systemPink : .white
    }
}
