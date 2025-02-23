//
//  AppColor.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

/// Enum providing standardized colors used throughout the app
enum AppColor {
    /// Private enum containing semantic color groupings
    private enum Semantic {
        /// Colors used for branding and primary actions
        enum Brand {
            static let primary: UIColor = .systemBlue
        }
        
        /// Colors used for text content
        enum Text {
            static let primary: UIColor = .black
            static let secondary: UIColor = .gray
        }
        
        /// Colors used for table view styling
        enum TableView {
            static let background: UIColor = .systemGray6
            static let cellBackground: UIColor = .white
            static let sectionBackground: UIColor = .systemGray4
            static let sectionSeparator: UIColor = .systemGray5
        }
        
        /// Colors used to indicate state changes
        enum State {
            static let positive: UIColor = .systemGreen
            static let negative: UIColor = .systemRed
        }
    }
    
    /// Primary brand color used for key UI elements
    static var primaryColor: UIColor {
        return Semantic.Brand.primary
    }
    
    /// Primary text color for main content
    static var textPrimaryColor: UIColor {
        return Semantic.Text.primary
    }
    
    /// Secondary text color for supporting content
    static var textSecondaryColor: UIColor {
        return Semantic.Text.secondary
    }
    
    /// Background color for table views
    static var tableViewBackgroundColor: UIColor {
        return Semantic.TableView.background
    }
    
    /// Background color for table view cells
    static var tableViewCellBackgroundColor: UIColor {
        return Semantic.TableView.cellBackground
    }
    
    /// Background color for table view sections
    static var tableViewSectionBackgroundColor: UIColor {
        return Semantic.TableView.sectionBackground
    }
    
    /// Color for table view section separators
    static var tableViewSectionSeparatorColor: UIColor {
        return Semantic.TableView.sectionSeparator
    }
    
    /// Color indicating positive change/growth
    static var positiveGainColor: UIColor {
        return Semantic.State.positive
    }
    
    /// Color indicating negative change/loss
    static var negativeGainColor: UIColor {
        return Semantic.State.negative
    }
    
    /// Color for navigation bar titles
    static var navTitleColor: UIColor {
        return .white
    }
    
    /// Background color for favorited table view cells
    static var favoritedCellBackgroundColor: UIColor {
        return primaryColor.withAlphaComponent(0.15)
    }
}
