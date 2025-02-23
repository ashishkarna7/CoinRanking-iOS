//
//  CoinListView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

class CoinListView: BaseListView {
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [CoinFilterType.all.value,
                                                          CoinFilterType.highestprice.value,
                                                          CoinFilterType.performance24h.value])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func create() {
        super.create()
    }
    
}
