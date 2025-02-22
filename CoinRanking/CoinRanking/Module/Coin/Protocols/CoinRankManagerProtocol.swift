//
//  RankManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

protocol CoinRankManagerProtocol {

    func executeCoinList(page: Int, filterType: CoinFilterType) -> AnyPublisher<[CoinListItemViewModel], ErrorResponse>
    func executeCoinDetail(uuid: String, period: ChartPeriodType) -> AnyPublisher<CoinDetailItemViewModel?, ErrorResponse>
    
    var isLastPageTriggered: PassthroughSubject<Bool, Never> { get set }
    var isEmptyContent: PassthroughSubject<Bool, Never> { get set }
    
    func getCoinItems(for filterType: CoinFilterType) -> [CoinListItemViewModel]
    func addFavorite(uuid: String)
    func removeFavorite(uuid: String)
    func removeData()
    func getFetchStatus(filterType: CoinFilterType) -> Bool
    func getLastPageStatus(filterType: CoinFilterType) -> Bool
    func getCoinDetail(uuid: String) -> CoinDetailItemViewModel
}
