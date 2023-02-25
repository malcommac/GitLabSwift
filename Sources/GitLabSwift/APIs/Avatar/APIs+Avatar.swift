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

// MARK: - Avatar + URLs

extension APIService.Avatar {
    
    fileprivate enum URLs: String, GLEndpoint {
        case get = "/avatar"
            
        public var value: String { rawValue }
    }
    
}

// MARK: - Avatar + APIs

extension APIService {
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/avatar.html)
    public class Avatar: APIService {
        
        /// Get a single avatar URL for a user with the given email address.
        ///
        /// - Parameters:
        ///   - email: Public email address of the user.
        ///   - size: Single pixel dimension (because images are squares).
        /// - Returns: avatar.
        public func url(email: String, size: Int? = nil) async throws -> GLResponse<Model.Avatar> {
            let options = OutputParamsCollection([
                OutputParam(key: "email", email),
                OutputParam(key: "size", size)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
    }
}
