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

// MARK: - IssuesStatistics + URLs

extension APIs.IssuesStatistics {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/issues_statistics"
        case groups = "/groups/{id}/issues_statistics"
        case project = "/projects/{id}/issues_statistics"

        public var value: String { rawValue }
    }
    
}

// MARK: - IssuesStatistics + APIs

extension APIs {
    
    /// Issues statistics API
    /// 
    /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html)
    public class IssuesStatistics: APIs {
        
        /// Gets issues count statistics on all issues.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-issues-statistics)
        ///
        /// - Parameter options: configuration callback.
        /// - Returns: list of issues
        public func list(options: ((SearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Issue]> {
            let options = SearchOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Gets issues count statistics for given group.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-group-issues-statistics)
        ///
        /// - Parameters:
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - options: configuration callback.
        /// - Returns: issues
        public func list(group: Int,
                         options: ((SearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Issue]> {
            let options = SearchOptions(options)
            options.customOptions = [
                OutputParam(key: "id", group)
            ]
            return try await gitlab.execute(.init(endpoint: URLs.groups, options: options))
        }
        
        /// Gets issues count statistics for given project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-project-issues-statistics)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: configuration callback.
        /// - Returns: issues list
        public func list(project: InputParams.Project,
                         options: ((SearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Issue]> {
            let options = SearchOptions(options)
            options.customOptions = [
                OutputParam(key: "id", project)
            ]
            return try await gitlab.execute(.init(endpoint: URLs.project, options: options))
        }
    }
    
}
