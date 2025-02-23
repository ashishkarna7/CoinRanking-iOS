//
//  AppScreen.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

/// Utility class providing screen dimensions
final class AppScreen {
    
    /// Returns the width of the device screen in points
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// Returns the height of the device screen in points 
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
