//
//  ViewState.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

/**
 Enum holds the possible view state
 */
enum ViewState {
    case idle // do nothing
    case loading // show loading
    case loadingWithText(String) // show loading with text
    case loadingCompleteWithText // hide loading view with text
    case success(String) // show success toast
    case error(Error) // show error toast
    case refreshConrolLoading
    case empty(String?)
    case paginationLoading
}
