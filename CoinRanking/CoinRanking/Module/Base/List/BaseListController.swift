//
//  BaseListController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

class BaseListController: BaseController, UITableViewDelegate, UITableViewDataSource {
    
    var screenView: BaseListView {
        return baseView as! BaseListView
    }
    
    var viewModel: BaseListViewModel {
        return baseViewModel as! BaseListViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.tableView.delegate = self
        screenView.tableView.dataSource = self
        observeEvents()
    }
    
    @objc private func refreshData() {
        viewModel.getItemList(type: .refresh)
    }
    
    private func observeEvents() {
        viewModel.didContentFetched
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.screenView.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel.showNoResultOption
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.screenView.showEmptyLabel(msg: LocalizedKeys.noResultFound.value)
            })
            .store(in: &cancellables)
        
        screenView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func loadPaginatedData(indexPaths: [IndexPath]) {
        self.screenView.tableView.insertRows(at: indexPaths, with: .none)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRow(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == viewModel.paginationSection,
           indexPath.row == viewModel.getNumberOfRow(at: indexPath.section) - 4 {
            viewModel.getItemList(type: .pagination)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
