//
//  NetworkLogger.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import Combine
import os

/// A utility struct for logging network requests and responses
struct NetworkLogger {
    /// The OS log instance used for network logging
    /// - Note: Uses the app's bundle identifier or "NetworkLogger" as fallback for the subsystem
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "NetworkLogger", category: "Networking")

    /// Logs details of a network request including URL, headers and body
    /// - Parameter request: The URLRequest to log
    static func logRequest(_ request: URLRequest) {
        guard let url = request.url else { return }
        
        os_log("➡️ Request: %{PUBLIC}@ %{PUBLIC}@", log: log, type: .debug, request.httpMethod ?? "UNKNOWN", url.absoluteString)

        if let headers = request.allHTTPHeaderFields {
            os_log("📩 Headers: %{PUBLIC}@", log: log, type: .debug, headers.description)
        }

        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            os_log("📤 Body: %{PUBLIC}@", log: log, type: .debug, bodyString)
        }
    }

    /// Logs details of a network response including status code and response data
    /// - Parameters:
    ///   - response: The URLResponse to log
    ///   - data: Optional Data received in the response
    static func logResponse(_ response: URLResponse?, data: Data?) {
        guard let httpResponse = response as? HTTPURLResponse, let url = httpResponse.url else { return }
        
        os_log("⬅️ Response (%d): %{PUBLIC}@", log: log, type: .debug, httpResponse.statusCode, url.absoluteString)

        if let data = data {
            let formattedJSON = formatJSON(data)
            os_log("📥 Response Data: %{PUBLIC}@", log: log, type: .debug, formattedJSON)
        }
    }
    
    /// Formats JSON data into a human-readable string
    /// - Parameter data: The Data containing JSON to format
    /// - Returns: A formatted JSON string or error message if parsing fails
    private static func formatJSON(_ data: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            return "❌ JSON Parsing Error: \(error.localizedDescription)"
        }
    }
    
    /// Formats a JSON string into a human-readable format
    /// - Parameter jsonString: The JSON string to format
    /// - Returns: A formatted JSON string or the original string if parsing fails
    private static func formatJSON(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8) else { return jsonString }
        return formatJSON(data)
    }
}
