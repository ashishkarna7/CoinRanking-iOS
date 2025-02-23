//
//  CoinStatisticsView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

class CoinStatisticsView: BaseView {
    
    lazy var marketCapView: StatisticItemView = {
        let view = StatisticItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceAtView: StatisticItemView = {
        let view = StatisticItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var allTimeHighView: StatisticItemView = {
        let view = StatisticItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [marketCapView,
                                                       priceAtView,
                                                       allTimeHighView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func create() {
        addSubview(containerStackView)
        generateChildren()
        
        marketCapView.titleLabel.text = "\(LocalizedKeys.marketCap.value) :"
        priceAtView.titleLabel.text = "\(LocalizedKeys.priceAt.value) :"
        allTimeHighView.titleLabel.text = "\(LocalizedKeys.allTimeHigh.value) "
    }
    
    private func generateChildren() {
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    func config(vm: CoinDetailItemViewModel) {
        if let marketCap = vm.marketCap {
            marketCapView.descriptionLabel.text = marketCap
        }
        
        if let priceAt = vm.priceAt {
            priceAtView.descriptionLabel.text = priceAt
        }
        
        if let allTimeHigh = vm.allTimeHigh {
            allTimeHighView.descriptionLabel.text = allTimeHigh
        }
    }
}


class StatisticItemView: BaseView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func create() {
        addSubview(containerStackView)
        generateChildren()
    }
    
    private func generateChildren() {
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
