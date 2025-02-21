//
//  TargetType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

// MARK: - TargetType Protocol

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Encodable? { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var authentication: Authentication { get }

    // Optional: Allows to customize the request before it is sent.
    func modifyRequest(_ request: inout URLRequest)
}

extension TargetType {
    // Default implementation: Does nothing by default.
    func modifyRequest(_ request: inout URLRequest) {}
}


// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH" // Added PATCH
}

// MARK: - Parameter Encoding
enum ParameterEncoding {
    case queryString
    case jsonBody
    case custom((Encodable) -> Data?)
    
    static func ==(lhs: ParameterEncoding, rhs: ParameterEncoding) -> Bool {
        switch (lhs, rhs) {
        case (.queryString, .queryString), (.jsonBody, .jsonBody):
            return true
        case (.custom, .custom):
            // Comparing custom closures is not straightforward; return false or add custom comparison logic.
            return false
        default:
            return false
        }
    }
    
    func encode<Parameters: Encodable>(_ parameters: Parameters) -> Data? {
        switch self {
        case .queryString:
            return parameters.asQueryString() // Extension defined below
        case .jsonBody:
            return try? JSONEncoder().encode(parameters)
        case .custom(let encodingClosure):
            return encodingClosure(parameters)
        }
    }
}

// MARK: - Extensions

extension Encodable {
    func asQueryString() -> Data? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }

        let queryItems = json.compactMap { key, value in
            switch value {
            case let v as String:
                return URLQueryItem(name: key, value: v)
            case let v as Int:
                return URLQueryItem(name: key, value: String(v))
            case let v as Bool:
                return URLQueryItem(name: key, value: String(v))
            case let v as Double:
                return URLQueryItem(name: key, value: String(v))
            case let v as [Any]:
                return URLQueryItem(name: key, value: v.description)
            case let v as [String]:
                return URLQueryItem(name: key, value: v.joined(separator: ","))
            default:
                return nil // Or handle other types as needed
            }
        }
        var components = URLComponents()
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }
}


// MARK: - Authentication

enum Authentication {
    case none
    case basic(username: String, password: String)
    case bearer(token: String)
    case custom((URLRequest) -> URLRequest?)

    func apply(to request: URLRequest) -> URLRequest {
        var mutableRequest = request
        switch self {
        case .basic(let username, let password):
            let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString()
            mutableRequest.setValue("Basic \(credentials ?? "")", forHTTPHeaderField: "Authorization")
        case .bearer(let token):
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .custom(let authClosure):
            return authClosure(mutableRequest) ?? mutableRequest // Provide default in case of nil
        case .none:
            break
        }
        return mutableRequest
    }
}
