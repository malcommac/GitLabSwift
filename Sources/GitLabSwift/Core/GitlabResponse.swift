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

/// The generic response received from server.
public protocol Response {
    
    /// HTTP raw response.
    var httpResponse: HTTPResponse { get }
    
}

/// GitLab response.
public class GitLabResponse<Object: Decodable>: Response {
    
    // MARK: - Public Properties
    
    /// Raw response from server.
    public let httpResponse: HTTPResponse
        
    // MARK: - Pages Inspector
    
    /// Current represented page.
    public var currentPage: Int {
        httpResponse.headers.intValue(forKey: CustomHTTPHeaders.currentPage.rawValue, defaultValue: 1)
    }
    
    /// Next page, if any.
    public var nextPage: Int? {
        httpResponse.headers.int(forKey: CustomHTTPHeaders.nextPage.rawValue)
    }
    
    /// Previous page, if any.
    public var prevPage: Int? {
        httpResponse.headers.int(forKey: CustomHTTPHeaders.previousPage.rawValue)
    }
    
    /// Total number of pages.
    public var totalPages: Int {
        httpResponse.headers.intValue(forKey: CustomHTTPHeaders.countPages.rawValue, defaultValue: 1)
    }
    
    /// Total number of items across pages.
    public var totalItems: Int? {
        httpResponse.headers.int(forKey: CustomHTTPHeaders.countItems.rawValue)
    }
    
    /// Total number of items per page.
    public var countItemsPerPage: Int? {
        httpResponse.headers.int(forKey: CustomHTTPHeaders.itemsPerPage.rawValue)
    }
    
    // MARK: - Private Properties
    
    /// Decoder used to read data. It's inerethied from client.
    private let jsonDecoder: JSONDecoder
    
    /// Cached decoded object.
    private var _value: Object?

    // MARK: - Initialization
    
    /// Initialize a new response from gitlab service from a raw http response.
    ///
    /// - Parameter httpResponse: http response received.
    internal init(httpResponse: HTTPResponse, decoder: JSONDecoder?) {
        self.httpResponse = httpResponse
        self.jsonDecoder = decoder ?? JSONDecoder()
    }
    
    // MARK: - Public Functions
    
    /// Decoded object from JSON data.
    ///
    /// - Returns: parsed object, may throws if parsing fails.
    public func model() throws -> Object? {
        if let _value {
            return _value
        }
        
        guard let data = httpResponse.data else {
            throw GitlabError(message: "Empty data received", response: self, request: nil)
        }
                
        _value = try jsonDecoder.decode(Object.self, from: data)
        return _value
    }
    
    // MARK: - Private Functions
    
    public func writeRawResponse(_ name: String) {
        if #available(macOS 13.0, *) {
            try! httpResponse.data?.write(to: URL(filePath: "/Users/daniele/Desktop/\(name).json"))
        } else {
            // Fallback on earlier versions
        }
    }
    
}
