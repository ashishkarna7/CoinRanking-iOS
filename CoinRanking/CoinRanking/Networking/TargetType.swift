//
//  TargetType.swift
//  CoinRanking
//
//  Created by Ashish Karna on 20/02/2025.
//

import Foundation

/// Protocol defining the requirements for network API targets
///
/// This protocol provides a standardized way to define API endpoints and their properties.
/// It includes essential properties like URL components, HTTP method, parameters, and authentication.
protocol TargetType {
    /// The base URL for the API endpoint
    var baseURL: String { get }
    
    /// The path component that will be appended to the base URL
    var path: String { get }
    
    /// The HTTP method to be used for the request
    var method: HTTPMethod { get }
    
    /// Optional parameters to be included in the request
    var parameters: Encodable? { get }
    
    /// The encoding strategy to use for the parameters
    var parameterEncoding: ParameterEncoding { get }
    
    /// Optional HTTP headers to include with the request
    var headers: [String: String]? { get }
    
    /// The authentication method to use for the request
    var authentication: Authentication { get }

    /// Optional method to modify the URLRequest before it is sent
    /// - Parameter request: The URLRequest to modify
    func modifyRequest(_ request: inout URLRequest)
}

extension TargetType {
    /// Default empty implementation for modifyRequest
    func modifyRequest(_ request: inout URLRequest) {}
}

/// Represents HTTP methods supported by the API
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Defines how parameters should be encoded in the request
enum ParameterEncoding {
    /// Encode parameters as URL query string
    case queryString
    /// Encode parameters as JSON in request body
    case jsonBody
    /// Custom encoding using provided closure
    case custom((Encodable) -> Data?)
    
    /// Equality comparison for ParameterEncoding
    /// - Parameters:
    ///   - lhs: Left hand side ParameterEncoding
    ///   - rhs: Right hand side ParameterEncoding
    /// - Returns: Boolean indicating if encodings are equal
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
    
    /// Encodes parameters according to the specified encoding type
    /// - Parameter parameters: The parameters to encode
    /// - Returns: Encoded data or nil if encoding fails
    func encode<Parameters: Encodable>(_ parameters: Parameters) -> Data? {
        switch self {
        case .queryString:
            return parameters.asQueryString()
        case .jsonBody:
            return try? JSONEncoder().encode(parameters)
        case .custom(let encodingClosure):
            return encodingClosure(parameters)
        }
    }
}

// MARK: - Extensions

extension Encodable {
    /// Converts an Encodable object to a URL query string
    /// - Returns: Data representation of the query string or nil if conversion fails
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
                return nil
            }
        }
        var components = URLComponents()
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }
}

/// Defines different authentication methods for API requests
enum Authentication {
    /// No authentication
    case none
    /// Basic authentication with username and password
    case basic(username: String, password: String)
    /// Bearer token authentication
    case bearer(token: String)
    /// Custom authentication using provided closure
    case custom((URLRequest) -> URLRequest?)

    /// Applies the authentication method to a URLRequest
    /// - Parameter request: The request to authenticate
    /// - Returns: Modified URLRequest with authentication applied
    func apply(to request: URLRequest) -> URLRequest {
        var mutableRequest = request
        switch self {
        case .basic(let username, let password):
            let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString()
            mutableRequest.setValue("Basic \(credentials ?? "")", forHTTPHeaderField: "Authorization")
        case .bearer(let token):
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .custom(let authClosure):
            return authClosure(mutableRequest) ?? mutableRequest
        case .none:
            break
        }
        return mutableRequest
    }
}
