//
//  RankListItemTableViewCell.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit
import SDWebImage

class CoinItemTableViewCell: BaseTableViewCell {
    
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
        label.textColor = AppColor.textPrimaryColor
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinChangeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinWrapperView,
                                                       coinNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinPriceLabel,
                                                       coinChangeLabel])
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
    
    private lazy var imageSize: CGSize = {
        let width: CGFloat = AppScreen.screenWidth * 0.1
        return CGSize(width: width, height: width)
    }()
    
    override func create() {
        contentView.backgroundColor = AppColor.tableViewBackgroundColor
        containerView.backgroundColor = AppColor.tableViewCellBackgroundColor
        contentView.addSubview(containerView)
        generateChildren()
    }
    
    private func generateChildren() {
      
        containerView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        })
        
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        coinImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(imageSize.width)
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
    
    func config(vm: CoinListItemViewModel) {
        coinNameLabel.text = vm.name
        coinPriceLabel.text = vm.price
        coinChangeLabel.text = vm.change
        coinChangeLabel.textColor = vm.isChangePositive ? AppColor.positiveGainColor : AppColor.negativeGainColor
        if let url = vm.iconUrl {
            coinImageView.sd_setImage(with: url,
                                      placeholderImage: nil,
                                      options: [],
                                      context: [.imageThumbnailPixelSize: imageSize])
        }
        containerView.backgroundColor = vm.isFavorite ? AppColor.favoritedCellBackgroundColor : AppColor.tableViewCellBackgroundColor
    }
}
