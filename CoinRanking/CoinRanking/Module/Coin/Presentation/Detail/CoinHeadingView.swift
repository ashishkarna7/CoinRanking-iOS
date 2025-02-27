//
//  CoinHeadingView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

class CoinHeadingView: BaseView {
    
   private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private  lazy var symbolTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.heading
        label.textColor = AppColor.textSecondaryColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  lazy var coinWrapperView: UIView = {
        let view = UIView()
        view.addSubview(coinImageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private  lazy var coinPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textSecondaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinPriceTitleLabel,
                                                       coinPriceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private  lazy var coinChangeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textSecondaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var coinChangeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.heading
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinChangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinChangeTitleLabel,
                                                       coinChangeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var coinChangeWrapperView: UIView = {
        let view = UIView()
        view.addSubview(coinChangeStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinPriceStackView,
                                                       coinChangeWrapperView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var priceStackWrapperView: UIView = {
        let view = UIView()
        view.addSubview(priceStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinWrapperView,
                                                       symbolTitleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeStackView, priceStackWrapperView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageSize: CGSize = {
        let width: CGFloat = AppScreen.screenWidth * 0.15
        return CGSize(width: width, height: width)
    }()
    
    override func create() {
        backgroundColor = AppColor.tableViewCellBackgroundColor
        addSubview(containerStackView)
        generateChildren()
        
        coinPriceTitleLabel.text = LocalizedKeys.price.value + " : "
        coinChangeTitleLabel.text = LocalizedKeys.change.value + " : "
    }
    
    private func generateChildren() {
        containerStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        coinImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(imageSize.width)
            make.top.left.equalToSuperview()
            make.right.bottom.lessThanOrEqualToSuperview()
        })
        
        priceStackView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        coinChangeStackView.snp.makeConstraints({ make in
            make.right.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
        })
    }
    
    func config(vm: CoinDetailItemViewModel) {
        coinPriceLabel.text = vm.price
        coinChangeLabel.text = vm.change
        coinChangeLabel.textColor = vm.isChangePositive ? AppColor.positiveGainColor : AppColor.negativeGainColor
        if let symbol = vm.symbol {
            symbolTitleLabel.text = symbol
        }

        if let url = vm.iconUrl {
            coinImageView.sd_setImage(with: url,
                                      placeholderImage: nil,
                                      options: [],
                                      context: [.imageThumbnailPixelSize: imageSize])
        }
    }
}
