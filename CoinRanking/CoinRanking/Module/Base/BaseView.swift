//
//  BaseView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import UIKit
import SnapKit

/**
 Method to add the custom childs
 */
protocol BaseViewPresentable: AnyObject {
    func create()
}

class BaseView: UIView, BaseViewPresentable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         create()
     }
    
    lazy var loadingMessageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textSecondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = AppColor.primaryColor
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loadingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityIndicatorView,
                                                       loadingMessageLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var loadingContainerView: UIView = {
        let view = UIView()
        view.addSubview(loadingStackView)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(loadingContainerView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColor.primaryColor
        return refreshControl
    }()

    lazy var noResultLabel: UILabel = {
       let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textSecondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var paginationSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = AppColor.primaryColor
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: AppScreen.screenWidth, height: 44)
        return spinner
    }()
   
     // Creating subview
      func create() {
      }
    
    func showLoadingIndicator(message: String) {
        self.addSubview(overlayView)
        loadingMessageLabel.text = message
        activityIndicatorView.startAnimating()
        overlayView.snp.makeConstraints({ make in
            make.top.bottom.left.right.equalToSuperview()
        })
        
        loadingContainerView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(85)
        })
        
        loadingStackView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        loadingMessageLabel.snp.makeConstraints({ make in
            make.height.equalTo(30)
        })
        
    }
    
    func showLoadingView() {
        showLoadingIndicator(message: "")
        loadingMessageLabel.isHidden = true
        loadingContainerView.snp.remakeConstraints({ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(85)
        })
    }
    
    func hideLoadingIndicator() {
        activityIndicatorView.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    func showEmptyLabel(msg: String) {
        addSubview(noResultLabel)
        noResultLabel.text = msg
        noResultLabel.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
    }
    
    func hideEmptyLabel() {
        noResultLabel.removeFromSuperview()
    }
    
}


