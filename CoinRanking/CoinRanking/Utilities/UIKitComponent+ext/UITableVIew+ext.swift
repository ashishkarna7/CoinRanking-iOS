//
//  UITableVIew+ext.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

extension UITableView {
    
    func registerClass(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: "\(cellClass.self)")
    }
    
    func dequeueReusableCell<T : UITableViewCell>(withClassIdentifier cell: T.Type) -> T {
        if let Cell = dequeueReusableCell(withIdentifier: String(describing: cell.self)) as? T {
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
}

