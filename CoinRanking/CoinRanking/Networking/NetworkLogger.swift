//
//  NetworkLogger.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import Foundation
import Combine
import os

struct NetworkLogger {
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "NetworkLogger", category: "Networking")

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

    static func logResponse(_ response: URLResponse?, data: Data?) {
        guard let httpResponse = response as? HTTPURLResponse, let url = httpResponse.url else { return }
        
        os_log("⬅️ Response (%d): %{PUBLIC}@", log: log, type: .debug, httpResponse.statusCode, url.absoluteString)

        if let data = data {
            let formattedJSON = formatJSON(data)
            os_log("📥 Response Data: %{PUBLIC}@", log: log, type: .debug, formattedJSON)
        }
    }
    
    /// Formats JSON data to a readable string
       private static func formatJSON(_ data: Data) -> String {
           do {
               let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
               let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
               return String(decoding: prettyData, as: UTF8.self)
           } catch {
               return "❌ JSON Parsing Error: \(error.localizedDescription)"
           }
       }
    
    /// Overloaded method to format JSON from a string
     private static func formatJSON(_ jsonString: String) -> String {
         guard let data = jsonString.data(using: .utf8) else { return jsonString }
         return formatJSON(data)
     }
}
