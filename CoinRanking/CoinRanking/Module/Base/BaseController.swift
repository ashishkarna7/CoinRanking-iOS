//
//  BaseController.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit
import Combine
import SwiftMessages

/// Base view controller class that provides common functionality for all view controllers
///
/// This class provides:
/// - Base view and view model management
/// - Combine subscription handling
/// - View state observation and UI updates
/// - Loading indicator management
/// - Snackbar message display
class BaseController: UIViewController {
    /// The base view instance that this controller manages
    var baseView: BaseView
    
    /// The base view model instance that provides data and business logic
    var baseViewModel: BaseViewModel
    
    /// Storage for Combine cancellables to properly manage memory
    var cancellables: Set<AnyCancellable>
    
    /// Not supported - use init(view:viewModel:) instead
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    /// Not supported - use init(view:viewModel:) instead
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    /// Initializes the controller with a view and view model
    /// - Parameters:
    ///   - view: The base view instance to manage
    ///   - viewModel: The base view model instance to provide data
    required init(view: BaseView, viewModel: BaseViewModel) {
        cancellables = Set<AnyCancellable>()
        baseView = view
        baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        // Configure base view layout
        self.view.subviews.forEach { $0.removeFromSuperview() }
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaInsets.top)
            make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            make.left.equalTo(self.view.safeAreaInsets.left)
            make.right.equalTo(self.view.safeAreaInsets.right)
        }
        
        // Observe view state changes
        baseViewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
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
            }
            .store(in: &cancellables)
    }
    
    /// Hides all loading indicators and overlays
    private func hideOverlay() {
        self.baseView.refreshControl.endRefreshing()
        self.baseView.paginationSpinner.stopAnimating()
        self.baseView.hideLoadingIndicator()
    }
}

// MARK: - Snackbar Message Handling
extension BaseController {
    /// Shows a snackbar message with the specified theme and duration
    /// - Parameters:
    ///   - message: The message to display
    ///   - theme: The visual theme for the message
    ///   - duration: Display duration in seconds (0 for infinite)
    func showSnackBar(message: String, theme: Theme, duration: Int) {
        guard !message.isEmpty else { return }
        
        DispatchQueue.main.async {
            let snackbarView = MessageView.viewFromNib(layout: .tabView)
            snackbarView.configureTheme(theme)
            snackbarView.configureDropShadow()
            
            var config = SwiftMessages.defaultConfig
            config.duration = duration == 0 ? .forever : .automatic
            
            snackbarView.titleLabel?.text = ""
            snackbarView.button?.isHidden = true
            snackbarView.configureContent(body: message)
            
            SwiftMessages.show(config: config, view: snackbarView)
        }
    }
    
    /// Shows a snackbar message with an action button
    /// - Parameters:
    ///   - message: The message to display
    ///   - theme: The visual theme for the message
    ///   - duration: Display duration in seconds (1 for infinite)
    func showActionSnackBar(message: String, theme: Theme, duration: Int) {
        let view = MessageView.viewFromNib(layout: .tabView)
        view.configureTheme(backgroundColor: AppColor.primaryColor, foregroundColor: UIColor.white)
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        config.duration = duration == 1 ? .forever : .automatic
        
        view.button?.setTitle("Retry".uppercased(), for: .normal)
        view.buttonTapHandler = { _ in
            // Handle retry action
        }
        view.configureContent(body: message)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    /// Hides all currently displayed snackbar messages
    func hideSnackBar() {
        SwiftMessages.hideAll()
    }
}
