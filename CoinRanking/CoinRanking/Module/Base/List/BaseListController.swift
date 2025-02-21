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
    
    private func observeEvents() {
        viewModel.didContentFetched
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.screenView.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRow(at: section)
    }
}
