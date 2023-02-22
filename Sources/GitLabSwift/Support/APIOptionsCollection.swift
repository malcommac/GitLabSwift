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
import RealHTTP

// MARK: - APIOptionsCollection

/// This class represent a collection of API options to define the behaviour of a call.
/// You can use this class to send custom variables set or create a subclass to have
/// a typed class with options for a specific call.
public class APIOptionsCollection: OptionsConvertible {
    
    // MARK: - Pagination Options
    
    /// Results per page in response. When not specified `20` is used.
    @APIOption(key: "per_page") public var perPage: Int?
    
    /// Current page number.
    @APIOption(key: "page") public var page: Int?
    
    /// Any other custom variable not declared by the options class.
    public var customOptions: [APIParameterURLConvertible]
    
    // MARK: - Initialization
    
    public init(_ custom: [APIParameterURLConvertible?] = []) {
        self.customOptions = custom.compactMap({ $0 })
    }
    
}

// MARK: - OptionsConvertible

/// This protocol specifiy an option which is convertible to one or
/// more `URLQueryItem` parameter which will be attacched to a request.
public protocol OptionsConvertible {
    
    /// Query items produced by the option. Most of options produce a single query item
    /// - Returns: [URLQueryItem]
    func encodedOptions() throws -> OptionsData
    
    /// Defines extra custom options parameter not specified as `@APIOption`.
    var customOptions: [APIParameterURLConvertible] { get }
    
}

extension OptionsConvertible {
    
    public func encodedOptions() throws -> OptionsData {
        var urlQueryItems = [URLQueryItem]()
        var jsonBodyDictionary = [String: Any]()
        let multipartForm = HTTPBody.MultipartForm()
        
        // Iterate over class definided `APIOptions` properties.
        for variable in Mirror(reflecting: self).apiURLAnnotatedVariables() {
            switch variable.location {
            case .parameterInQueryURL:
                if let variableQueryItems = try variable.queryItems() {
                    urlQueryItems.append(contentsOf: variableQueryItems)
                }
            case .jsonFragmentInBody:
                if variable.location == .jsonFragmentInBody, let fragment = variable.jsonFragment {
                    jsonBodyDictionary[variable.key] = fragment
                }
            case .fileInForm:
                if let filePath = variable.value as? String {
                    try multipartForm.add(string: "@\(filePath)", name: "file")
                }
            }
        }
        
        
        // Iterate over custom options array.
        for variable in self.customOptions {
            switch variable.location {
            case .parameterInQueryURL:
                try urlQueryItems.append(contentsOf: variable.queryItems() ?? [])
            case .jsonFragmentInBody:
                if variable.location == .jsonFragmentInBody, let fragment = variable.jsonFragment {
                    jsonBodyDictionary[variable.key] = fragment
                }
            case .fileInForm:
                if let filePath = variable.value as? String {
                    try multipartForm.add(string: "@\(filePath)", name: "file")
                }
            }
        }
        
        return .init(
            queryItems: urlQueryItems,
            jsonBody: (jsonBodyDictionary.isEmpty ? nil : jsonBodyDictionary),
            multipartFormData: (multipartForm.contentLength == 0 ? nil : multipartForm)
        )
    }
    
}

public struct OptionsData {
    
    let queryItems: [URLQueryItem]
    
    let jsonBody: [String: Any]?
    
    let multipartFormData: HTTPBody.MultipartForm?
    
}
