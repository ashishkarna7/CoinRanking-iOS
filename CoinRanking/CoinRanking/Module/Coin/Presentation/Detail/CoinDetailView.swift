//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

class CoinDetailView: BaseView {
 
    private lazy var headingView: CoinHeadingView = {
        let view = CoinHeadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headingView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(containerStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    override func create() {
        self.backgroundColor = AppColor.tableViewBackgroundColor
        addSubview(scrollView)
        generateChildren()
    }
    
    private func generateChildren() {
        scrollView.snp.makeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func config(vm: CoinDetailItemViewModel) {
        headingView.config(vm: vm)
    }
}


class CoinHeadingView: BaseView {
    
   private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private  lazy var coinWrapperView: UIView = {
        let view = UIView()
        view.addSubview(coinImageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private  lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.subHeading
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinChangeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimaryColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinPriceLabel,
                                                       coinChangeLabel])
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
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonWrapperView: UIView = {
        let view = UIView()
        view.addSubview(favoriteButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [coinWrapperView,
                                                       priceStackWrapperView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeStackView,
                                                       buttonWrapperView])
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
        backgroundColor = AppColor.tableViewSectionBackgroundColor
        addSubview(containerStackView)
        generateChildren()
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
        
        favoriteButton.snp.makeConstraints({ make in
            make.width.height.equalTo(imageSize.width)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
        })
    }
    
    func config(vm: CoinDetailItemViewModel) {
        coinPriceLabel.text = vm.price
        coinChangeLabel.text = vm.change
        coinChangeLabel.textColor = vm.isChangePositive ? AppColor.positiveGainColor : AppColor.negativeGainColor
        if let url = vm.iconUrl {
            coinImageView.sd_setImage(with: url,
                                      placeholderImage: nil,
                                      options: [],
                                      context: [.imageThumbnailPixelSize: imageSize])
        }
        let buttonImage = vm.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let tintColor = vm.isFavorite ? AppColor.primaryColor : AppColor.tableViewCellBackgroundColor
        favoriteButton.tintColor = tintColor
        favoriteButton.setImage(buttonImage, for: .normal)
    }
}
