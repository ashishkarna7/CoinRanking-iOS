//
//  BuildConfigManager.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation

final class BuildConfigManager {
    /// Singleton instance
    static let shared = BuildConfigManager()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /**
     Retrieves a value from Info.plist for the given key.
     - Parameter key: A `BuildConfig` enum case representing the key.
     - Returns: The value as `Any?` (String, Bool, or Double if convertible)
     */
    func value(for key: BuildConfig) -> Any? {
        guard let infoDict = Bundle.main.infoDictionary,
              let rawValue = infoDict[key.rawValue] as? String else {
            return nil
        }

        // Attempt to parse value into Bool or Double if applicable
        if let boolValue = Bool(rawValue) {
            return boolValue
        } else if let doubleValue = Double(rawValue) {
            return doubleValue
        }

        return rawValue
    }
}
