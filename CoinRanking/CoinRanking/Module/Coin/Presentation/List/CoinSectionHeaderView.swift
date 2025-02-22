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
    
    lazy var lineSeparatorLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.tableViewSectionSeparatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineSeparatorRightView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.tableViewSectionSeparatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeLabel, lineSeparatorLeftView])
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
                                                       lineSeparatorRightView,
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
                                                                     leading: 8,
                                                                     bottom: 8,
                                                                     trailing: 8)
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
        
        lineSeparatorLeftView.snp.makeConstraints({ make in
            make.width.equalTo(1)
        })
        
        lineSeparatorRightView.snp.makeConstraints({ make in
            make.width.equalTo(1)
        })
        
        priceLabel.text = "BTC Price"
        exchangeLabel.text = "Exchanges"
        changeLabel.text = "Change"
    }

}
