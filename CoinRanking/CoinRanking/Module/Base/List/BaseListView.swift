//
//  BaseListView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

class BaseListView: BaseView {
    
    lazy var tableView: UITableView = {
         let tableView = UITableView()
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 200.0
         tableView.separatorStyle = .none
         tableView.backgroundColor = AppColor.tableViewBackgroundColor
         tableView.sectionFooterHeight = 0
         tableView.sectionHeaderHeight = 0
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.backgroundColor = AppColor.tableViewBackgroundColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override func create() {
        addSubview(containerStackView)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = paginationSpinner
        generateChildren()
        tableView.backgroundColor = .red
    }
    
    private func generateChildren() {
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
