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

/// Represent a single request to GitLab APIs service.
public struct GLRequest {    
    
    // MARK: - Public Properties

    /// HTTP Method for request.
    public var httpMethod: HTTPMethod
    
    /// Endpoint for the call.
    public var endpoint: GLEndpoint?

    // MARK: - Private Properties
    
    /// Underlying parameters dictionary.
    public var options: OptionsConvertible?
    
    // MARK: - Internal Properties
    
    /// In order to support `nextPage()` and `prevPage()` from an already executed
    /// request, we can create a new `GLRequest` instance with an absolute url.
    internal var fixedURL: URL?
    
    // MARK: - Private Properties
    
    private static let urlTemplateCaptureRegEx = try! NSRegularExpression(pattern: "\\{(.*?)\\}")
    
    // MARK: - Initialization
    
    /// Initialize a new request for gitlab APIs.
    ///
    /// - Parameters:
    ///   - method: http method to use, default is `get`.
    ///   - endpoint: endpoint of the call.
    ///   - options: api options object.
    public init(_ method: HTTPMethod = .get,
                endpoint: GLEndpoint,
                options: OptionsConvertible = OutputParamsCollection()) {
        self.httpMethod = method
        self.options = options
        self.endpoint = endpoint
        self.fixedURL = nil
    }
    
    init(_ method: HTTPMethod = .get, fixedURL: URL) {
        self.httpMethod = method
        self.fixedURL = fixedURL
        self.endpoint = nil
        self.options = nil
    }
    
    // MARK: - Internal Functions
    
    internal func httpRequest(forClient gitlab: GLApi) throws -> HTTPRequest {
        if let fixedURL {
            return try httpRequest(forClient: gitlab, fixedURL: fixedURL)
        } else if let endpoint = self.endpoint, let options = self.options  {
            return try httpRequest(gitlab: gitlab, options: options, endpoint: endpoint)
        } else {
            fatalError()
        }
    }
    
    // MARK: - Private Functions
    
    private func httpRequest(forClient gitlab: GLApi, fixedURL: URL) throws -> HTTPRequest {
        HTTPRequest {
            $0.url = fixedURL
            $0.method = httpMethod
            if let auth = gitlab.config.authenticationToken() {
                $0.headers.set(auth.key, auth.value)
            }
        }
    }
    
    /// Create an executable http request for a given client.
    ///
    /// - Parameter gitlab: gitlab client where the request will be executed.
    /// - Returns: the request itself, throws if something went wrong.
    private func httpRequest(gitlab: GLApi, options: OptionsConvertible, endpoint: GLEndpoint) throws -> HTTPRequest {
        // Expand parameters and create the url based upon the request.
        let queryData = try options.encodedOptions()
        let allVariables = queryData.queryItems
        
        var jsonBody: HTTPBody?
        if let json = queryData.jsonBody {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            jsonBody = .data(jsonData, contentType: .json)
        }
        
        let fullPath = URITemplate(stringLiteral: endpoint.value).expand(withQueryItems: allVariables)
        let fullURL = gitlab.config.baseURL.absoluteString.appending(fullPath)

        // Values not used to compose the URI template will be used as query items.
        let URIUsedVariables = Set(GLRequest.urlTemplateCaptureRegEx.regExGroups(endpoint.value))
        let queryURLVariables: [URLQueryItem] = allVariables.filter {
            URIUsedVariables.contains($0.name) == false
        }
        
        return HTTPRequest {
            $0.url = URL(string: fullURL)
            $0.method = httpMethod
            if !queryURLVariables.isEmpty {
                $0.query = queryURLVariables
            }
            if let body = jsonBody {
                $0.body = body
            }
            if let formData = queryData.multipartFormData {
                $0.body = .multipart(formData)
            }
            if let auth = gitlab.config.authenticationToken() {
                $0.headers.set(auth.key, auth.value)
            }
        }
    }
    
}

// MARK: - GLEndpoint0

public protocol GLEndpoint {
    
    /// The raw endpoint path. It may contains variable for parameters
    /// expressed as `{variable_name}`.
    var value: String { get }

}
