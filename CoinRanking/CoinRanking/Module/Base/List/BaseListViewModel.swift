//
//  BaseListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

protocol ListItemViewModel {
    var uuid: String {get set}
}

class BaseListViewModel: BaseViewModel {
    
    private(set) var didContentFetched = PassthroughSubject<Bool, Never>()
    private(set) var showNoResultOption = PassthroughSubject<Bool, Never>()
    var isReloadCell = PassthroughSubject<IndexPath, Never>()
    var isRemoveCell = PassthroughSubject<IndexPath, Never>()
    
    private(set) var currentPageOffset: Int = 0
    var isLastPage = false
    private var canPerformPagination = true
    private(set) var shouldExecuteManager: Bool = true
    var paginationSection = 0
    
    private(set) var dictionaryItems: [Int: [ListItemViewModel]] = [:]
    
    func getNumberOfSection() -> Int {
        return 0
    }
    
    func getNumberOfRow(at section: Int) -> Int {
        return 0
    }
    
    func resetData() {
        
    }
    
    func showLoading(type: ContentLoadingType) {
        shouldExecuteManager = true
        switch type {
        case .initial:
            currentPageOffset = 0
            isLastPage = false
            self.viewState.send(.loading)
        case .refresh:
            currentPageOffset = 0
            isLastPage = false
            viewState.send(.refreshConrolLoading)
        case .pagination:
            guard canPerformPagination, !isLastPage else {
                shouldExecuteManager = false
                return
            }
            currentPageOffset += 1
            viewState.send(.paginationLoading)
        }
        self.canPerformPagination = false
    }
    
    func getItemList(type: ContentLoadingType) {}
    
    func handleCompletion<T: ListItemViewModel>(_ publisher: AnyPublisher<[T], ErrorResponse>) {
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let failure):
                    self.viewState.send(.error(failure))
                case .finished:
                    break
                }
            }, receiveValue: { list in
                self.processReceivedList(list)
            })
            .store(in: &cancellables)
    }

    private func processReceivedList<T: ListItemViewModel>(_ list: [T]) {
        self.viewState.send(.idle)
        
        guard !list.isEmpty else {
            if self.currentPageOffset == 0 {
                self.resetData()
                showNoResultOption.send(true)
                self.didContentFetched.send(true)
            }
            self.isLastPage = true
            return
        }
        
        self.didContentFetched.send(true)
  
        self.canPerformPagination = true
    }


}
