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
public class GLResponse<Object: Decodable>: Response {
    
    // MARK: - Public Properties
    
    /// Raw response from server.
    public let httpResponse: HTTPResponse
    
    /// Origin request.
    public var httpRequest: HTTPRequest? {
        httpResponse.request
    }
    
    // MARK: - Private Properties
    
    /// Reference to the client who have executed the request of this response.
    weak var gitlab: GLApi?
    var request: GLRequest?
        
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
    init(httpResponse: HTTPResponse, decoder: JSONDecoder?) {
        self.httpResponse = httpResponse
        self.jsonDecoder = decoder ?? JSONDecoder()
    }
    
    // MARK: - Public Functions
    
    /// Decoded object from JSON data.
    ///
    /// - Returns: parsed object, may throws if parsing fails.
    public func decode() throws -> Object? {
        if let _value {
            return _value
        }
        
        guard let data = httpResponse.data else {
            throw GLErrors.emptyData
        }
                
        _value = try jsonDecoder.decode(Object.self, from: data)
        return _value
    }
    
    /// Load the next page if available.
    ///
    /// - Returns: response of the next page.
    public func nextPage() async throws -> GLResponse<Object> {
        let (newRequest, api) = try createNewRequestFromOrigin()        
        guard currentPage <= totalPages else {
            throw GLErrors.pageLimitHasReached
        }
        
        newRequest.optionsData?.page = (currentPage + 1)
        return try await api.execute(newRequest)
    }
    
    /// Load results of the previous page.
    ///
    /// - Returns: response of the previous page.
    public func prevPage() async throws -> GLResponse<Object> {
        let (newRequest, api) = try createNewRequestFromOrigin()
        guard currentPage > 0 else {
            throw GLErrors.pageLimitHasReached
        }
        
        newRequest.optionsData?.page = (currentPage - 1)
        return try await api.execute(newRequest)
    }
    
    /// Load all the remaining pages and return when all response are collected.
    ///
    /// - Parameter count: count of pages to load,
    ///                    if `nil` load all the remaining pages according to the total number received in this call.
    /// - Returns: all remaining pages.
    public func nextPages(_ count: Int?) async throws -> [GLResponse<Object>] {
        guard currentPage != totalPages else {
            return []
        }
        
        var responses = [GLResponse<Object>]()
        
        let endPageIdx = (count != nil ? currentPage + count! : (totalPages - currentPage) )
        for pageIdx in (currentPage+1)...endPageIdx {
            let (newRequest, api) = try createNewRequestFromOrigin()
            newRequest.optionsData?.page = pageIdx
            let fetchResponse: GLResponse<Object> = try await api.execute(newRequest)
            responses.append(fetchResponse)
        }
        
        return responses
    }
    
    // MARK: - Private Functions
    
    /// Create a copy of the request and validate the service.
    ///
    /// - Returns: request and gitlab service.
    private func createNewRequestFromOrigin() throws -> (request: GLRequest, gitlab: GLApi) {
        guard let gitlab = self.gitlab,
              let newRequest = self.request else {
            throw GLErrors.failedToCreateRequest
        }
        
        return (newRequest, gitlab)
    }
    
    /// Write response data at file url.
    ///
    /// - Parameter fileURL: fileURL
    public func writeRawResponse(fileURL: URL) throws {
        guard let data = httpResponse.data else {
            return
        }
        
        try data.write(to: fileURL)
    }
    
}

extension GLRequest {
    
    var optionsData: OutputParamsCollection? {
        options as? OutputParamsCollection
    }
    
}
