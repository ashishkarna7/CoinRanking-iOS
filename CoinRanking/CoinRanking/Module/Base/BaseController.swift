//
//  BaseController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit
import Combine
import SwiftMessages

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
        
        baseViewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self = self else {return}
                switch state {
                case .idle:
                    self.hideOverlay()
                case .success(let message):
                    self.hideOverlay()
                    self.showSnackBar(message: message, theme: .success, duration: 1)
                case .error(let error):
                    self.hideOverlay()
                    self.showSnackBar(message: error.message, theme: .error, duration: 1)
                case .loading:
                    self.baseView.showLoadingView()
                case .refreshConrolLoading:
                    self.hideOverlay()
                    self.baseView.refreshControl.beginRefreshing()
                case .paginationLoading:
                    view.paginationSpinner.startAnimating()
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    private func hideOverlay() {
        self.baseView.refreshControl.endRefreshing()
        self.baseView.paginationSpinner.stopAnimating()
        self.baseView.hideLoadingIndicator()
    }
}

// MARK: - SNACKBAR AND PROGRESSHUD
extension BaseController {
    /**
        Method to show snackbar message
     */
    func showSnackBar(message:String,theme:Theme,duration:Int){
        if !message.isEmpty {
            DispatchQueue.main.async {
            let snackbarView = MessageView.viewFromNib(layout: .tabView)
                
            snackbarView.configureTheme(theme)
            snackbarView.configureDropShadow()
            var config = SwiftMessages.defaultConfig
            if duration == 0 {
            config.duration = .forever
            }else{
                config.duration = .automatic
            }
            snackbarView.titleLabel?.text = ""
            snackbarView.button?.isHidden = true
            snackbarView.configureContent(body: message)

            // Show the message.
            
                SwiftMessages.show(config:config,view: snackbarView)
            }
        }
    }
    
    /**
        Method to show snackbar message with button option
     */
    func showActionSnackBar(message:String,theme:Theme,duration:Int){
        let view = MessageView.viewFromNib(layout: .tabView)
        
        // Theme message elements with the warning style.
        //view.configureTheme(theme)
       view.configureTheme(backgroundColor: AppColor.primaryColor, foregroundColor: UIColor.white)
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        if duration == 1 {
            config.duration = .forever
        }else{
            config.duration = .automatic
        }
        
        view.button?.setTitle("Retry".uppercased(), for: .normal)

        view.buttonTapHandler = { _ in
            
        }
        view.configureContent(body: message)
        // Show the message.
        SwiftMessages.show(config:config,view: view)
    }
    
    /**
        Method to hide snackbar
     */
    func hideSnackBar(){
        SwiftMessages.hideAll()
    }
}
