//
//  RankListItemTableViewCell.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit
import SDWebImage

class RankListItemTableViewCell: BaseTableViewCell {
    
    lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var coinWrapperView: UIView = {
        let view = UIView()
        view.addSubview(coinImageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinChangeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinWrapperView,
                                                       coinNameLabel,
                                                       coinPriceLabel,
                                                       coinChangeLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16,
                                                                     leading: 16,
                                                                     bottom: 16,
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
    
    override func create() {
        containerView.backgroundColor = .red
        contentView.addSubview(containerView)
        generateChildren()
    }
    
    private func generateChildren() {
      
        containerView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        })
        
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        coinImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(40)
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
    
    func config(vm: RankListItemViewModel) {
        coinNameLabel.text = vm.name
        coinPriceLabel.text = vm.price
        coinChangeLabel.text = vm.change
        if let url = vm.iconUrl {
            coinImageView.sd_setImage(with: url)
        }
    }
}
