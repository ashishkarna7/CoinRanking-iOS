//
//  AppFont.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import UIKit

enum AppFont {
    
    static var heading: UIFont {
        return .boldSystemFont(ofSize: 16)
    }
    
    static var subHeading: UIFont {
        return .systemFont(ofSize: 16)
    }
    
    static var body: UIFont {
        return .systemFont(ofSize: 14)
    }
    
    static var caption: UIFont {
        return .systemFont(ofSize: 12)
    }
    
    static var footnote: UIFont {
        return .systemFont(ofSize: 10)
    }
    
    static var title: UIFont {
        return .boldSystemFont(ofSize: 20)
    }
}
