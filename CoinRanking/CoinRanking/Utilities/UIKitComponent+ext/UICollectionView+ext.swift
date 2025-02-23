//
//  UICollectionView+ext.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

extension UICollectionView {
    
    /// Registers a UICollectionViewCell class for reuse in the collection view
    /// - Parameter cellClass: The UICollectionViewCell class to register
    func registerClass(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass.self)")
    }
    
    /// Dequeues a reusable cell of the specified type
    /// - Parameters:
    ///   - cell: The UICollectionViewCell class type to dequeue
    ///   - indexPath: The index path specifying the location of the cell
    /// - Returns: A reusable cell of the specified type
    /// - Note: Will trigger a fatal error if cell cannot be dequeued or cast to specified type
    func dequeueReusableCell<T : UICollectionViewCell>(withClassIdentifier cell: T.Type, indexPath: IndexPath) -> T {
        if let Cell = dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as? T {
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
}
