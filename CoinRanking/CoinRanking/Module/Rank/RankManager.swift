//
//  RankManager.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//

import Combine

class RankManager: RankManagerProtocol {
    
    private var repository: RankRepositoryProtocol
    
    init(repository: any RankRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeRankList(page: Int) -> AnyPublisher<[RankListItemViewModel], ErrorResponse> {
        return repository.fetchRankList(page: page)
            .map { response in
                debugPrint(response)
                return response.data.coins.compactMap({RankListItemViewModel(coin: $0)})
            }
            .mapError { error in
                ErrorResponse(type: LocalizedKeys.networkError.value,
                              message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
