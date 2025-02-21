//
//  BaseController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit
import Combine


class BaseController: UIViewController {
    var baseView: BaseView
    var baseViewModel: BaseViewModel
    
    var cancellables: Set<AnyCancellable>
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    required init(view: BaseView, viewModel: BaseViewModel) {
        cancellables = Set<AnyCancellable>()
        baseView = view
        baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        
        // add screenview
        self.view.subviews.forEach({$0.removeFromSuperview()})
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints({ make in
            make.top.equalTo(self.view.safeAreaInsets.top)
            make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            make.left.equalTo(self.view.safeAreaInsets.left)
            make.right.equalTo(self.view.safeAreaInsets.right)
        })
        
//        // listen to viewstate
//        baseViewModel.viewState
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: {[weak self] (state) in
//                guard let self = self else {return}
//                switch state {
//                case .idle:
//                    self.hideOverlay()
//                case .success(let message):
//                    self.hideOverlay()
//                    self.showSnackBar(message: message, theme: .success, duration: 1)
//                case .error(let error):
//                    self.hideOverlay()
//                    if let err = error as? ErrorResponse, !err.message.isEmpty {
//                        // show error message in snack bar
//                        self.showSnackBar(message: err.message, theme: .error, duration: 1)
//                    } else {
//                        Logger.log(message: error.localizedDescription, event: .e)
//                    }
//                    
//                case .loading:
//                    // show loading screen
//                    self.baseView.showLoadingView()
//                case .loadingWithText(let message):
//                    self.hideOverlay()
//                    self.baseView.showLoadingIndicator(message: message)
//                case .loadingCompleteWithText:
//                    self.hideOverlay()
//                    self.baseView.hideLoadingIndicator()
//                case .refreshConrolLoading:
//                    self.hideOverlay()
//                    self.baseView.refreshControl.beginRefreshing()
//                case .empty(let message):
//                    self.hideOverlay()
//                    if let message = message {
//                        self.baseView.showEmptyLabel(msg: message)
//                    } else {
//                        self.baseView.hideEmptyLabel()
//                    }
//                    
//                case .retryVideoUpload:
//                    self.hideOverlay()
//                    let view = MessageView.viewFromNib(layout: .tabView)
//                    
//                    // Theme message elements with the warning style.
//                    view.configureTheme(.error)
//                    view.configureDropShadow()
//                    
//                    var config = SwiftMessages.defaultConfig
//                    config.duration = .automatic
//                    
//                    view.button?.setTitle("Retry Upload".localized, for: .normal)
//                    
//                    view.buttonTapHandler = { _ in
//                        Logger.log(message: "button tap", event: .i)
//                        self.baseViewModel.uploadVideo(videoUrl: self.baseViewModel.compressedVideoUrl)
//                    }
//                    view.titleLabel?.text = LocalizedKeys.serverError.value
//                    view.configureContent(body: "Video upload interrupted".localized)
//                    // Show the message.
//                    SwiftMessages.show(config:config,view: view)
//                case .paginationLoading:
//                    view.paginationSpinner.startAnimating()
//                }
//            }).disposed(by: self.disposeBag)

    }
    
    private func hideOverlay() {
        self.baseView.refreshControl.endRefreshing()
        self.baseView.paginationSpinner.stopAnimating()
        self.baseView.hideLoadingIndicator()
    }
}
