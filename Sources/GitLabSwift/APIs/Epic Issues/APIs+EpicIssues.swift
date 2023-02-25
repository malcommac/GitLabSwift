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

// MARK: - EpicIssues + URLs

extension APIService {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/groups/{id}/epics/{epic_iid}/issues"
        case assign = "/groups/{id}/epics/{epic_iid}/issues/{issue_id}"
        case epic_issue_id = "/groups/{id}/epics/{epic_iid}/issues/{epic_issue_id}"
        
        public var value: String { rawValue }
    }
    
}

// MARK: - EpicIssues + APIs

extension APIService {
    
    /// Epic Issues API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html)
    public class EpicIssues: APIService {
        
        /// Gets all issues that are assigned to an epic and the authenticated user has access to.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#list-issues-for-an-epic)
        ///
        /// - Parameters:
        ///   - epic: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user.
        /// - Returns: list of issues
        public func list(epic: Int,
                         project: InputParams.ProjectID) async throws -> GLResponse<[Model.Issue]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "epic_iid", epic)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
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
        public func assign(issue: Int,
                           epic: Int,
                           project: InputParams.ProjectID) async throws -> GLResponse<Model.EpicIssueAssociation> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "epic_iid", epic),
                OutputParam(key: "issue_id", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.assign, options: options))
        }
        
        /// Removes an epic - issue association.
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#remove-an-issue-from-the-epic)
        ///
        /// - Parameters:
        ///   - association: The ID of the issue - epic association.
        ///   - epic: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: association
        public func removeIssueEpic(association: Int,
                                    epic: Int,
                                    project: InputParams.ProjectID) async throws -> GLResponse<Model.EpicIssueAssociation> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "epic_iid", epic),
                OutputParam(key: "epic_issue_id", association)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.epic_issue_id, options: options))
        }
        
        /// Updates an epic - issue association.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/epic_issues.html#update-epic---issue-association).
        ///
        /// - Parameters:
        ///   - association: The ID of the issue - epic association.
        ///   - epic: The internal ID of the epic.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - moveBefore: The ID of the issue - epic association that should be placed before the link in the question.
        ///   - moveAfter: The ID of the issue - epic association that should be placed after the link in the question.
        /// - Returns: ordered issues of the epic.
        public func updateIssueEpic(association : Int,
                                    epic: Int,
                                    project: InputParams.ProjectID,
                                    moveBefore: Int? = nil,
                                    moveAfter: Int? = nil) async throws -> GLResponse<[Model.Issue]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "epic_iid", epic),
                OutputParam(key: "epic_issue_id", association),
                OutputParam(key: "move_before_id", moveBefore),
                OutputParam(key: "move_after_id", moveAfter)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.epic_issue_id, options: options))
        }
        
    }
    
}
