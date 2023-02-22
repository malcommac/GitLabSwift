//
//  GitLabSwift
//  Async/Await client for GitLab API v4, for Swift
//
//  Created & Maintained by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2023 Daniele Margutti.
//  Licensed under MIT License.
//

import Foundation

// MARK: - GitLabRequestVariable

public typealias ArrayOfHashes = [Hash]
public typealias Hash = [String: Any]

/// Represent the generic protocol used to transform a single parameter to a list of
/// query items used to create the query.
public protocol APIParameterURLConvertible {
    
    /// Query server parameter key.
    var key: String { get }
    
    /// Where the options should be placed.
    var location: APIOptionLocation { get }
    
    /// If `location` is query URL it will return one or more query items for URL request.
    /// - Returns: `[URLQueryItem]`
    func queryItems() throws -> [URLQueryItem]?
    
    /// If `location` is json it will return a json fragment.
    var jsonFragment: Any? { get }
    
    var value: Any? { get }
    
}

public enum APIOptionLocation {
    case jsonFragmentInBody
    case parameterInQueryURL
    case fileInForm
}

// MARK: - GitLabParameter

@propertyWrapper
/// Define a single parameter you can send with a request to GitLab Rest API service.
/// From a single parameter you may get one or more query URL parameters, expressed as
/// `URLQueryItem`. It happens, for example, with integer arrays.
public struct APIOption<Value/*: URLEncodable*/>: APIParameterURLConvertible {
    
    // MARK: - Public Properties
    
    /// Where the options should be placed.
    public var location: APIOptionLocation
    
    /// Represent the key used for parameter inside the URL query.
    public let key: String
    
    /// Value represented by the property.
    /// Keep in mind only non `nil` values are sent to compose the URL query.
    public var wrappedValue: Value?
    
    // MARK: - Initialization
    
    /// Initialize a new API parameter with a given key and value.
    ///
    /// - Parameters:
    ///   - key: key to assign.
    ///   - dest: where the option should be placed, by default is query url.
    ///   - value: value to set, by default `nil` is used.
    init(key: String, location: APIOptionLocation = .parameterInQueryURL, _ value: Value? = nil) {
        self.key = key
        self.location = location
        self.wrappedValue = value
    }
    
    public var jsonFragment: Any? {
        guard let wrappedValue, location == .jsonFragmentInBody else {
            return nil
        }
        
        return wrappedValue
    }
    
    public var value: Any? {
        wrappedValue
    }
    
    /// Return the associated `URLQueryItem` used to compose the query to gitlab service.
    ///
    /// - Returns: list of `URLQueryItem` which represent the value of the parameter.
    public func queryItems() throws -> [URLQueryItem]? {
        guard let wrappedValue, location == .parameterInQueryURL else {
            return nil
        }
        
        switch wrappedValue.self {
        case let value as [Int]:
            // Int
            return value.map {
                .init(name: "\(key)[]", value: $0.encodedValue)
            }
        case let value as [String]:
            // String
            return value.map {
                .init(name: "\(key)[]", value: $0.encodedValue)
            }
        case let value as Hash:
            // Hash
            // <https://docs.gitlab.com/ee/api/rest/index.html#hash>
            return value.map { (itemKey, itemValue) in
                .init(name: "\(key)[\(itemKey)]", value: String(describing: itemValue))
            }
        case let hashesArray as ArrayOfHashes:
            // Array of hashes
            // <https://docs.gitlab.com/ee/api/rest/index.html#array-of-hashes>
            var queryItems = [URLQueryItem]()
            for index in 0..<hashesArray.count {
                let currentHash = hashesArray[index]
                for itemKey in currentHash.keys {
                    if let value = currentHash[itemKey] {
                        queryItems.append(
                            .init(name: "\(key)[\(index)][\(itemKey)]",
                                  value: String(describing: value)
                                 )
                        )
                    }
                }
            }
            return queryItems
        case let encodableValue as URLEncodable:
            return [
                URLQueryItem(name: key, value: encodableValue.encodedValue)
            ]
        default:
            fatalError("Value of type \(String(describing: type(of: wrappedValue))) not conform to URLEncodable")
        }
    }
    
}
