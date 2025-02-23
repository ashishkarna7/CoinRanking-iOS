//
//  CoinListItemViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Foundation

/// View model class for displaying individual coin items in a list
/// Handles coin data formatting and favorite status management
class CoinListItemViewModel: ListItemViewModel {
    /// Unique identifier for the coin
    var uuid: String
    
    /// Name of the coin
    private(set) var name: String
    
    /// Formatted price string with $ symbol and 2 decimal places
    private(set) var price: String
    
    /// Percentage change string with % symbol
    private(set) var change: String
    
    /// URL for the coin's icon image
    private(set) var iconUrl: URL?
    
    /// Whether the coin is marked as a favorite
    private(set) var isFavorite: Bool
    
    /// Whether the price change is positive or negative
    private(set) var isChangePositive: Bool
    
    /// Initializes view model from a Coin model
    /// - Parameter coin: The coin model containing raw data
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
    
    /// Creates a copy of an existing view model
    /// - Parameter vm: The view model to copy
    init(vm: CoinListItemViewModel) {
        self.uuid = vm.uuid
        self.name = vm.name
        self.price = vm.price
        self.change = vm.change
        self.isFavorite = vm.isFavorite
        self.isChangePositive = vm.isChangePositive
        self.iconUrl = vm.iconUrl
    }
    
    /// Sets the favorite status to a specific value
    /// - Parameter value: The new favorite status
    func setFavorite(value: Bool) {
        self.isFavorite = value
    }
    
    /// Marks the coin as a favorite
    func addFavorite() {
        self.isFavorite = true
    }
    
    /// Removes the coin from favorites
    func removeFavorite() {
        self.isFavorite = false
    }
}
