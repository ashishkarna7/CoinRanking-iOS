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
    
    func executeRankList(page: Int) -> AnyPublisher<[CoinListItemViewModel], ErrorResponse> {
        return repository.fetchRankList(page: page)
            .map { response in
                [CoinListItemViewModel(response: response)]
            }
            .mapError { error in
                ErrorResponse(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
