//
//  RankListController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//


import Foundation
import UIKit

class RankListController: BaseListController {
    
    override var viewModel: RankListViewModel {
        return baseViewModel as! RankListViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Exchange Listing"

        // Register header view
        screenView.tableView.register(RankListHeaderView.self, forHeaderFooterViewReuseIdentifier: RankListHeaderView.identifier)
        screenView.tableView.registerClass(RankListItemTableViewCell.self)
        viewModel.getItemList(type: .initial)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure large title is displayed when first shown
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            
            // Set Navigation Bar Color
            navigationController?.navigationBar.barTintColor = AppColor.primaryColor  // Primary Color
            
            // Set Title Color
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: AppColor.navTitleColor
            ]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankListHeaderView.identifier) as? RankListHeaderView else { return nil }
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.getItem(from: indexPath) as? RankListItemViewModel else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withClassIdentifier: RankListItemTableViewCell.self)
        cell.config(vm: item)
        return cell
    }
}
