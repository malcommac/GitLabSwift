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

extension HTTPHeaders {
    
    /// Read an integer value from headers with a given key, returning fallback value if not found.
    ///
    /// - Parameters:
    ///   - key: key to retrive.
    ///   - defaultValue: default value in case of failure.
    /// - Returns: parsed or default value
    public func intValue(forKey key: String, defaultValue: Int) -> Int {
        guard let strValue = value(for: key) else {
            return defaultValue
        }
        
        return Int(strValue) ?? defaultValue
    }
    
    /// Read integer value from headers with a given key, if not exists return `nil`.
    ///
    /// - Parameter key: key to retrive.
    /// - Returns: parsed value, `nil` if not exists.
    public func int(forKey key: String) -> Int? {
        guard let strValue = value(for: key) else {
            return nil
        }
        
        return Int(strValue)
    }
    
}

extension NSRegularExpression {

    func regExMatches(_ string: String) -> [String] {
        let results = matches(in: string, range: NSRange(string.startIndex..., in: string))
        return results.map {
            String(string[Range($0.range, in: string)!])
        }
    }
    
    func regExGroups(_ string: String) -> [String] {
        let foundMatches = matches(in: string, range: NSRange(string.startIndex..., in: string))
        return foundMatches.compactMap { match in
            guard match.numberOfRanges > 1 else {
                return [String]()
            }
            
            return (1..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: string) else {
                    return ""
                }
                return String(string[range])
            }
        }.flatMap({ $0 })
    }
    
}

// MARK: - URITemplate

extension URITemplate {
    
    /// Expand using an array of query items. It will not allow duplicates (like array) but
    /// we are sure no duplicate keys are used inside the URL parameters.
    ///
    /// - Parameter queryItems: query items.
    /// - Returns: String
    internal func expand(withQueryItems queryItems: [URLQueryItem]) -> String {
        var dictionary = [String: Any]()
        for queryItem in queryItems {
            dictionary[queryItem.name] = queryItem.value
        }
        return expand(dictionary)
    }
    
}

// MARK: - GitLab Custom HTTP Headers

internal enum CustomHTTPHeaders: String {
    case currentPage = "X-Page"
    case previousPage = "X-Prev-Page"
    case nextPage = "X-Next-Page"
    case countItems = "X-Total"
    case itemsPerPage = "X-Per-Page"
    case requestId = "X-Request-Id"
    case countPages = "X-Total-Pages"
}

// MARK: - Mirror Extension

extension Mirror {
    
    /// Return all @APIOption annoated variables of a class, including super class properties.
    ///
    /// - Returns: `[APIParameterURLConvertible]`
    func apiURLAnnotatedVariables() -> [APIParameterURLConvertible] {
        var allVariables = [APIParameterURLConvertible]()
        
        for property in children {
            if let variable = property.value as? APIParameterURLConvertible {
                allVariables.append(variable)
            }
        }
        
        // Add properties of superclass:
        if let parent = self.superclassMirror {
            allVariables.append(contentsOf: parent.apiURLAnnotatedVariables())
        }
        
        return allVariables
    }
    
}
