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

extension APIService {
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html).
    public class IssuesStatistics: APIService {
        
        /// Gets issues count statistics on all issues.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-issues-statistics)
        ///
        /// - Parameter callback: configuration callback.
        /// - Returns: list of issues
        public func list(_ callback: ((APIOptions.IssueStatisticsSearch) -> Void)? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.IssueStatisticsSearch(callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.IssuesStatistics.list, options: options))
        }
        
        /// Gets issues count statistics for given group.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-group-issues-statistics)
        ///
        /// - Parameters:
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - callback: configuration callback.
        /// - Returns: issues
        public func list(group: Int,
                         _ callback: ((APIOptions.IssueStatisticsSearch) -> Void)? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.IssueStatisticsSearch(callback)
            options.customOptions = [
                APIOption(key: "id", group)
            ]
            return try await gitlab.execute(.init(endpoint: Endpoints.IssuesStatistics.groups, options: options))
        }
        
        /// Gets issues count statistics for given project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues_statistics.html#get-project-issues-statistics)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback.
        /// - Returns: issues list
        public func list(project: DataTypes.ProjectID,
                         _ callback: ((APIOptions.IssueStatisticsSearch) -> Void)? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.IssueStatisticsSearch(callback)
            options.customOptions = [
                APIOption(key: "id", project)
            ]
            return try await gitlab.execute(.init(endpoint: Endpoints.IssuesStatistics.project, options: options))
        }
    }
    
}
