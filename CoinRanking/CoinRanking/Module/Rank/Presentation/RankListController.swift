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
        
        screenView.tableView.registerClass(RankListItemTableViewCell.self)
        viewModel.getItemList(type: .initial)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.getItem(from: indexPath) as? RankListItemViewModel else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withClassIdentifier: RankListItemTableViewCell.self)
        cell.config(vm: item)
        return cell
    }
}
