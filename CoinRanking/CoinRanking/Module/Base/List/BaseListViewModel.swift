//
//  BaseListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

/// Protocol defining required properties for list item view models
protocol ListItemViewModel {
    /// Unique identifier for the list item
    var uuid: String {get set}
}

/// Base view model class for list-based views that handles pagination and content loading
class BaseListViewModel: BaseViewModel {
    
    /// Publisher that emits when content has been fetched successfully
    private(set) var didContentFetched = PassthroughSubject<Bool, Never>()
    
    /// Publisher that emits when no results are found
    private(set) var showNoResultOption = PassthroughSubject<Bool, Never>()
    
    /// Publisher that emits when a cell needs to be reloaded
    var isReloadCell = PassthroughSubject<IndexPath, Never>()
    
    /// Publisher that emits when a cell needs to be removed
    var isRemoveCell = PassthroughSubject<IndexPath, Never>()
    
    /// Current page offset for pagination
    private(set) var currentPageOffset: Int = 0
    
    /// Flag indicating if the last page has been reached
    var isLastPage = false
    
    /// Flag controlling whether pagination can be performed
    private var canPerformPagination = true
    
    /// Flag indicating if the manager should execute
    private(set) var shouldExecuteManager: Bool = true
    
    /// Section index used for pagination
    var paginationSection = 0
    
    /// Returns the number of sections in the list
    /// - Returns: Number of sections (default 0)
    func getNumberOfSection() -> Int {
        return 0
    }
    
    /// Returns the number of rows in a given section
    /// - Parameter section: Section index
    /// - Returns: Number of rows (default 0)
    func getNumberOfRow(at section: Int) -> Int {
        return 0
    }
    
    /// Resets the list data
    func resetData() {
        
    }
    
    /// Configures loading state based on content loading type
    /// - Parameter type: Type of content loading (initial, refresh, or pagination)
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
    
    /// Fetches items for the list based on loading type
    /// - Parameter type: Type of content loading
    func getItemList(type: ContentLoadingType) {}
    
    /// Handles completion of list item fetching
    /// - Parameter publisher: Publisher that emits array of list items
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

    /// Processes the received list items and updates view state
    /// - Parameter list: Array of list items
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
