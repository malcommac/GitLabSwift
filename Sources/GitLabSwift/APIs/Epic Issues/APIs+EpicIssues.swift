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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html).
    public class EpicIssues: APIService {
        
        /// Gets all issues that are assigned to an epic and the authenticated user has access to.
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#list-issues-for-an-epic)
        ///
        /// - Parameters:
        ///   - epic: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: list of issues
        public func list(epic iid: Int,
                         ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "epic_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.EpicIssues.list, options: options))
        }
        
        /// Creates an epic - issue association.
        /// If the issue in question belongs to another epic it is unassigned from that epic.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#assign-an-issue-to-the-epic)
        ///
        /// - Parameters:
        ///   - issueIid: The ID of the issue.
        ///   - epicIid: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: the link created
        public func assign(issue iid: Int,
                           toEpic epicIid: Int,
                           ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.EpicIssueAssociation> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "epic_iid", epicIid),
                APIOption(key: "issue_id", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.EpicIssues.assign, options: options))
        }
        
        /// Removes an epic - issue association.
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#remove-an-issue-from-the-epic)
        ///
        /// - Parameters:
        ///   - iid: The ID of the issue - epic association.
        ///   - epicIid: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: association
        public func remove(issueEpicAssociation associationIid: Int,
                           fromEpic epicIid: Int,
                           ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.EpicIssueAssociation> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "epic_iid", epicIid),
                APIOption(key: "epic_issue_id", associationIid)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.EpicIssues.epicIssueId, options: options))
        }
        
        /// Updates an epic - issue association.
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#update-epic---issue-association).
        ///
        ///
        /// - Parameters:
        ///   - associationIid: The ID of the issue - epic association.
        ///   - epicIid: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - moveBefore: The ID of the issue - epic association that should be placed before the link in the question.
        ///   - moveAfter: The ID of the issue - epic association that should be placed after the link in the question.
        /// - Returns: ordered issues of the epic.
        public func update(issueEpicAssociation associationIid: Int,
                           fromEpic epicIid: Int,
                           ofProject project: DataTypes.ProjectID,
                           moveBefore: Int? = nil,
                           moveAfter: Int? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "epic_iid", epicIid),
                APIOption(key: "epic_issue_id", associationIid),
                APIOption(key: "move_before_id", moveBefore),
                APIOption(key: "move_after_id", moveAfter)
            ])
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.EpicIssues.epicIssueId, options: options))
        }
        
    }
    
}
