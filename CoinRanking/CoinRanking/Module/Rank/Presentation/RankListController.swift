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
        setupFilterSegmentControl()
        // Register header view
        screenView.tableView.register(RankListHeaderView.self, forHeaderFooterViewReuseIdentifier: RankListHeaderView.identifier)
        screenView.tableView.registerClass(RankListItemTableViewCell.self)
        viewModel.getItemList(type: .initial)
    }
    
    private func setupFilterSegmentControl() {
        let filterSegmentedControl = UISegmentedControl(items: ["All", "Highest Price", "Best 24h"])
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)

        navigationItem.titleView = filterSegmentedControl
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {}

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
    
    // MARK: - Swipe to Favorite
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completion in
            guard let self = self else { return }
            guard let item = viewModel.getItem(from: indexPath) as? RankListItemViewModel else {return}
            // Toggle favorite status
            item.toggleFavorite()
            
            // Reload row with animation
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        favoriteAction.backgroundColor = .systemBlue
        favoriteAction.image = UIImage(systemName: "star.fill")
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
