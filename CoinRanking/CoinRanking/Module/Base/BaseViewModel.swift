//
//  BaseViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

/// Base view model class that provides common functionality for all view models
///
/// This class provides:
/// - Cancellable storage for managing Combine subscriptions
/// - View state management through a CurrentValueSubject
/// - Basic initialization
class BaseViewModel {
    
    /// Storage for Combine cancellables to properly manage memory
    var cancellables: Set<AnyCancellable>
    
    /// Subject that emits the current view state
    /// Defaults to .idle state on initialization
    var viewState = CurrentValueSubject<ViewState, Never>(.idle)
    
    /// Initializes a new BaseViewModel instance
    /// Sets up an empty cancellables set
    init() {
        self.cancellables = Set<AnyCancellable>()
    }
}
