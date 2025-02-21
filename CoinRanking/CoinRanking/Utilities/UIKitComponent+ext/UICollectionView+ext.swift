//
//  UICollectionView+ext.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

extension UICollectionView {
    
    func registerClass(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass.self)")
    }
    
    func dequeueReusableCell<T : UICollectionViewCell>(withClassIdentifier cell: T.Type, indexPath: IndexPath) -> T {
        if let Cell = dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as? T {
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
}
