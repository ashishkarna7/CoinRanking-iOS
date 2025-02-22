//
//  RankListController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 21/02/2025.
//


import Foundation
import UIKit

class CoinListController: BaseListController {
    
    override var screenView: CoinListView {
        return baseView as! CoinListView
    }
    
    override var viewModel: CoinListViewModel {
        return baseViewModel as! CoinListViewModel
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
        screenView.tableView.register(CoinSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CoinSectionHeaderView.identifier)
        screenView.tableView.registerClass(CoinItemTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getItemList(type: .initial)
    }
    
    private func setupFilterSegmentControl() {
        screenView.segmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        navigationItem.titleView = screenView.segmentedControl
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
        let favoriteVC = CoinListController(view: CoinListView(),
                                            viewModel: CoinListViewModel(manager: viewModel.manager,
                                                                         type: .favorite))
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CoinSectionHeaderView.identifier) as? CoinSectionHeaderView else { return nil }
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: CoinItemTableViewCell.self)
        if let item = viewModel.getItem(from: indexPath) {
            cell.config(vm: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel.getItem(from: indexPath) {
            self.navigateToDetail(uuid: item.uuid)
        }
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
    
    private func navigateToDetail(uuid: String) {
        
        let coinDetailVC = CoinDetailController(view: CoinDetailView(),
                                                viewModel: CoinDetailViewModel(manager: viewModel.manager,
                                                                               detail: viewModel.getCoinDetail(uuid: uuid)))
        self.navigationController?.pushViewController(coinDetailVC, animated: true)
    }
}
