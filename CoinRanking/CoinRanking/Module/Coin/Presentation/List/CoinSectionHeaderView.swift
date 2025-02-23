//
//  RankListHeaderView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

class CoinSectionHeaderView: UITableViewHeaderFooterView {
    
    lazy var exchangeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel,
                                                       changeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeStackView,
                                                       priceStackView])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8,
                                                                     leading: 16,
                                                                     bottom: 8,
                                                                     trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(containerStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier = "RankListHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = AppColor.tableViewSectionBackgroundColor
        contentView.addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        priceLabel.text = LocalizedKeys.price.value
        exchangeLabel.text = LocalizedKeys.coin.value
        changeLabel.text = LocalizedKeys.change.value
    }

}
