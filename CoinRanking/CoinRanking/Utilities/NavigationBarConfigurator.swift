//
//  NavigationBarConfigurator.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

/// Utility class for configuring global navigation bar appearance
final class NavigationBarConfigurator {
    
    /// Applies the global navigation bar style for the app
    /// - Sets opaque background with primary color
    /// - Configures title text color
    /// - Enables large titles
    /// - Applies standard and compact appearances
    static func applyGlobalStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.primaryColor
        appearance.titleTextAttributes = [
            .foregroundColor: AppColor.navTitleColor
        ]

        // Apply the appearance globally
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = nil
        navBar.compactAppearance = appearance
        navBar.prefersLargeTitles = true
    }
}
