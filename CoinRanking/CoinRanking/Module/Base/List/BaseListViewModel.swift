//
//  BaseListViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

protocol ListItemViewModel {
    var uid: String {get set}
}

class BaseListViewModel: BaseViewModel {
    
    private(set) var didContentFetched = PassthroughSubject<Bool, Never>()
    private(set) var showNoResultOption = PassthroughSubject<(Bool, String?)?, Never>()
    private(set) var isPaginatedContentLoaded = PassthroughSubject<[IndexPath], Never>()
    var isReloadCell = PassthroughSubject<IndexPath, Never>()
    var isRemoveCell = PassthroughSubject<IndexPath, Never>()
    
    private(set) var currentPage: Int = 1
    private var isLastPage = false
    private var canPerformPagination = true
    var itemsPerPage: Int = 0
    private(set) var shouldExecuteManager: Bool = true
    var paginationSection = 0
    
    private(set) var dictionaryItems: [Int: [ListItemViewModel]] = [:]
    
    func getNumberOfSection() -> Int {
        return dictionaryItems.count
    }
    
    func getNumberOfRow(at section: Int) -> Int {
        return dictionaryItems[section]?.count ?? 0
    }
    
    func getItem(from indexPath: IndexPath) -> ListItemViewModel? {
        if indexPath.section < getNumberOfSection() {
            if let items = dictionaryItems[indexPath.section] {
                if indexPath.row < getNumberOfRow(at: indexPath.section) {
                    return items[indexPath.row]
                }
            }
        }
        return nil
    }
    
    func showLoading(type: ContentLoadingType) {
        shouldExecuteManager = true
        switch type {
        case .initial:
            currentPage = 1
            isLastPage = false
            self.viewState.send(.loading)
        case .refresh:
            currentPage = 1
            isLastPage = false
            viewState.send(.refreshConrolLoading)
        case .pagination:
            guard canPerformPagination, !isLastPage else {
                shouldExecuteManager = false
                return
            }
            currentPage += 1
            viewState.send(.paginationLoading)
        }
        self.canPerformPagination = false
    }
    
    func getItemList(type: ContentLoadingType) {}
    
    func handleCompletion<T: ListItemViewModel>(result: Result<[T], ErrorResponse>) {
            switch result {
            case .success(let list):
                self.viewState.send(.idle)
                guard !list.isEmpty else {
                    if self.currentPage == 1 {
                        showNoResultOption.send((true, LocalizedKeys.noResultFound.value))
                    } else {
                        showNoResultOption.send((false, nil))
                    }
                    self.isLastPage = true
                    return
                }
                
                if list.count < itemsPerPage {
                    self.isLastPage = true
                }
                
                if self.currentPage == 1 {
                    // For initial load or refresh, replace existing items.
                    self.dictionaryItems.removeAll()
                    self.dictionaryItems[self.paginationSection] = list
                    self.didContentFetched.send(true)
                } else {
                    // For pagination, append the new items and generate index paths for reloading.
                    var items = self.dictionaryItems[self.paginationSection] ?? []
                    let previousCount = items.count
                    let currentCount = previousCount + list.count
                    items.append(contentsOf: list)
                    self.dictionaryItems[self.paginationSection] = items
                    let indexPaths = (previousCount..<currentCount).map({IndexPath(row: $0, section: self.paginationSection)})
                    self.isPaginatedContentLoaded.send(indexPaths)
                }
                self.canPerformPagination = true
            case .failure(let failure):
                self.viewState.send(.error(failure))
            }
        }
}
