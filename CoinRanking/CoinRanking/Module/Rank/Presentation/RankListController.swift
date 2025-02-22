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
        if viewModel.filterType == .favorite {
            self.navigationItem.title = "Favorites"
        } else {
            self.navigationItem.title = "Exchange Listing"
            setupFilterSegmentControl()
            setupFavoriteButton()
        }
        // Register header view
        screenView.tableView.register(RankListHeaderView.self, forHeaderFooterViewReuseIdentifier: RankListHeaderView.identifier)
        screenView.tableView.registerClass(RankListItemTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getItemList(type: .initial)
    }
    
    private func setupFilterSegmentControl() {
        let filterSegmentedControl = UISegmentedControl(items: [FilterType.all.value,
                                                                FilterType.price.value,
                                                                FilterType.volume.value])
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)

        navigationItem.titleView = filterSegmentedControl
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        viewModel.applyFilter(tag: sender.selectedSegmentIndex)
    }
    
    private func setupFavoriteButton() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func showFavorites() {
        let favoriteVC = RankListController(view: BaseListView(),
                                            viewModel: RankListViewModel(manager: viewModel.manager,
                                                                         type: .favorite))
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankListHeaderView.identifier) as? RankListHeaderView else { return nil }
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: RankListItemTableViewCell.self)
        let item = viewModel.getItem(from: indexPath)
        cell.config(vm: item)
        return cell
    }
    
    // MARK: - Swipe to Favorite
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completion in
            guard let self = self else { return }
            // Toggle favorite status
            viewModel.toggleFavorite(at: indexPath)
            
            // Reload row with animation
            tableView.reloadData()
            
            completion(true)
        }
        
        favoriteAction.backgroundColor = .systemBlue
        favoriteAction.image = UIImage(systemName: "star.fill")
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
