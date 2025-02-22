//
//  RankManagerProtocol.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine
import Foundation

protocol RankManagerProtocol {
    var isLastPageTriggered: PassthroughSubject<Bool, Never> { get set }
    var isEmptyContent: PassthroughSubject<Bool, Never> { get set }
    func executeRankList(page: Int, filterType: FilterType) -> AnyPublisher<[RankListItemViewModel], ErrorResponse>
    func getCoinItems(for filterType: FilterType) -> [RankListItemViewModel]
    func addFavorite(uuid: String)
    func removeFavorite(uuid: String)
    func removeData()
    func getFetchStatus(filterType: FilterType) -> Bool
    func getLastPageStatus(filterType: FilterType) -> Bool
}
