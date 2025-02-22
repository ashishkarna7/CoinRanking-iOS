//
//  NavigationBarConfigurator.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit

final class NavigationBarConfigurator {
    
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

