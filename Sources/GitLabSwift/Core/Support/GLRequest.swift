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
public class GLRequest: APIRequestsURLConvertible {
    
    // MARK: - Public Properties

    /// HTTP Method for request.
    public var httpMethod: HTTPMethod
    
    /// Endpoint for the call.
    public var endpoint: GLEndpoint

    // MARK: - Private Properties
    
    /// Underlying parameters dictionary.
    public var options: OptionsConvertible
    
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
    }
    
    // MARK: - Internal Functions
    
    /// Create an executable http request for a given client.
    ///
    /// - Parameter gitlab: gitlab client where the request will be executed.
    /// - Returns: the request itself, throws if something went wrong.
    internal func httpRequest(forClient gitlab: GitLab) throws -> HTTPRequest {
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
