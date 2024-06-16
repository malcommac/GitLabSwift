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
import Glider

public struct Config {
    
    // MARK: - Public Properties
    
    /// Gitlab API endpoint.
    /// By default `https://gitlab.com` is used.
    public var baseURL = URL(string: "https://gitlab.com")!
    
    /// JSON decoder used to decode raw data from server.
    public var jsonDecoder = JSONDecoder()
    
    /// Authentication style to use.
    public var token: String?
    
    /// Configuration of the logger.
    public var loggerConfiguration: Glider.Log.Configuration
    
    // MARK: - Initialization
    
    /// Initialize a new gitlab configuration.
    ///
    /// - Parameters:
    ///   - baseURL: base url of the service
    ///   - configuration: optional configuration callback.
    public init(baseURL: URL, _ configuration: ((inout Self) -> Void)? = nil) {
        self.baseURL = baseURL
        self.loggerConfiguration = .init({
            $0.level = .error
            $0.transports = [ConsoleTransport()]
        })
        self.jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let data = try container.decode(String.self)
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]
            guard let date = isoFormatter.date(from: data) else {
                // Attempt to parse `2022-12-01` date only
                let dateOnlyFormatter = DateFormatter()
                dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
                guard let parsedDateOnly = dateOnlyFormatter.date(from: data) else {
                    throw DecodingError.dataCorruptedError(in: container,
                                                           debugDescription: "Cannot decode date string \(data)")
                }
                return parsedDateOnly
            }
            return date
        })
        
        configuration?(&self)
    }
    
    // MARK: - Internal Functions
    
    /// Get the authentication header's key and values.
    ///
    /// - Returns: header key and value if available.
    func authenticationToken() -> (key: String, value: String)? {
        guard let token else { return nil }
        
        return ("Authorization", "Bearer " + token)
    }
}
