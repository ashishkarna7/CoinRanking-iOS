//
//  AppFont.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

/// Enum providing standardized font styles used throughout the app
enum AppFont {
    /// Font size constants for consistent typography
    private enum Size {
        static let title: CGFloat = 20
        static let heading: CGFloat = 16
        static let body: CGFloat = 14
        static let caption: CGFloat = 12
        static let footnote: CGFloat = 10
    }
    
    /// Large bold font used for main screen titles and headers
    static var title: UIFont {
        return .boldSystemFont(ofSize: Size.title)
    }
    
    /// Medium bold font used for section headings
    static var heading: UIFont {
        return .boldSystemFont(ofSize: Size.heading)
    }
    
    /// Regular medium font used for secondary headings
    static var subHeading: UIFont {
        return .systemFont(ofSize: Size.heading, weight: .regular)
    }
    
    /// Regular font used for body text and general content
    static var body: UIFont {
        return .systemFont(ofSize: Size.body, weight: .regular)
    }
    
    /// Smaller font used for supplementary information
    static var caption: UIFont {
        return .systemFont(ofSize: Size.caption, weight: .regular)
    }
    
    /// Smallest font used for auxiliary text and metadata
    static var footnote: UIFont {
        return .systemFont(ofSize: Size.footnote, weight: .regular)
    }
}
