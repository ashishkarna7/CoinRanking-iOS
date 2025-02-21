//
//  BaseViewModel.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation
import Combine

class BaseViewModel {
    
    var cancellables: Set<AnyCancellable>
    
    var viewState = CurrentValueSubject<ViewState, Never>(.idle)
    
    init() {
        self.cancellables = Set<AnyCancellable>()
    }
}
