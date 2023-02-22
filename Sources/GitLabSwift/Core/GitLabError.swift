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

public struct GitlabError: LocalizedError {
    
    // MARK: - Public Properties
    
    /// Received response.
    public let response: (any Response)?
    
    /// Origin request.
    public let request: GitLabRequest?
    
    /// Message received from gitlab in message field.
    public let message: String?
    
    /// Status code of the response.
    public var statusCode: HTTPStatusCode? {
        response?.httpResponse.statusCode
    }
    
    /// Description of the error.
    public var errorDescription: String? {
        message
    }
    
    // MARK: - Initialization
    
    /// Create a valid error object if response received represent an error.
    ///
    /// - Parameters:
    ///   - response: response received.
    ///   - request: origin request.
    internal init?(response: any Response, request: GitLabRequest) {
        guard (200...299).contains(response.httpResponse.statusCode.rawValue) == false else {
            return nil
        }

        if let data = response.httpResponse.data,
           let decodedError = try? JSONDecoder().decode(Model.ErrorResponse.self, from: data) {
            self.message = decodedError.message
        } else {
            self.message = "HTTP response received: \(response.httpResponse.statusCode.rawValue)"
        }
        
        self.response = response
        self.request = request
    }
    
    /// Initialize an internal error message.
    ///
    /// - Parameters:
    ///   - message: message to print.
    ///   - response: optional linked response.
    ///   - request: optional linked request.
    internal init(message: String, response: (any Response)? = nil, request: GitLabRequest? = nil) {
        self.message = message
        self.response = response
        self.request = request
    }
    
}
