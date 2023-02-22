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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html).
    public class Issues: APIService {
        
        /// Get all issues the authenticated user has access to.
        /// By default it returns only issues created by the current user.
        /// To get all issues, use parameter `scope=all`.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-issues)
        ///
        /// - Parameter callback: configuration callback.
        /// - Returns: found issues
        public func list(_ callback: ((APIOptions.SearchIssues) -> Void)? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.SearchIssues(callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.list, options: options))
        }
        
        /// Get a list of a group’s issues.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-group-issues)
        ///
        /// NOTE:
        /// If the group is private, credentials need to be provided for authorization.
        ///
        /// - Parameters:
        ///   - id: id of the group.
        ///   - callback: configuration callback.
        /// - Returns: found issues
        public func list(group id: Int,
                         _ callback: ((APIOptions.SearchGroupIssues) -> Void)? = nil) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.SearchGroupIssues(id: id, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.listGroups, options: options))
        }
        
        /// Get a list of a project’s issues.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-project-issues)
        ///
        /// NOTE:
        /// If the group is private, credentials need to be provided for authorization.
        ///
        /// - Parameters:
        ///   - id: id of the project.
        ///   - callback: configuration callback.
        /// - Returns: found issues
        public func list(project id: DataTypes.ProjectID,
                         _ callback: ((APIOptions.SearchProjectIssues) -> Void)? = nil)
            async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptions.SearchProjectIssues(id: id, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.listProjects, options: options))
        }
        
        /// Get a single issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#single-issue)
        ///
        /// - Parameter id: id of the issue to retrive.
        /// - Returns: found issue.
        public func get(_ id: Int) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.get, options: options))
        }
        
        /// Get a single project issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#single-project-issue)
        ///
        /// - Parameters:
        ///   - iid: iid of the issue.
        ///   - project: referenced project.
        /// - Returns: found issue
        public func get(_ iid: Int,
                        inProject project: DataTypes.ProjectID?) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.getInProject, options: options))
        }
        
        /// Creates a new project issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#new-issue)
        ///
        /// - Parameters:
        ///   - title: title of the issue.
        ///   - project: parent project.
        ///   - callback: configuration callback.
        public func create(title: String,
                           inProject project: DataTypes.ProjectID,
                           _ callback: ((APIOptions.CreateIssue) -> Void)? = nil) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptions.CreateIssue(title: title, project: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.listProjects, options: options))
        }
        
        /// Updates an existing project issue.
        /// This call is also used to mark an issue as closed.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#edit-issue)
        ///
        /// - Parameters:
        ///   - iid: iid of the issue.
        ///   - project: parent project.
        ///   - callback: configuration callbaxck.
        /// - Returns: updated issue.
        public func edit(_ iid: Int,
                         inProject project: DataTypes.ProjectID,
                         _ callback: ((APIOptions.EditIssue) -> Void)? = nil) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptions.EditIssue(iid: iid, project: project, callback)
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.Issues.listProjects, options: options))
        }
        
        /// Deletes an issue.
        /// Only for administrators and project owners.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#delete-an-issue)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: Reference project.
        /// - Returns: no response.
        public func delete(_ iid: Int,
                           inProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Issues.getInProject, options: options))
        }
        
        /// Reorders an issue, you can see the results when sorting issues manually.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reorder-an-issue).
        ///
        /// - Parameters:
        ///   - iid: target issue global id of the issue.
        ///   - project: referenced project.
        ///   - beforeIid: The global ID of a project’s issue that should be placed after this issue
        ///   - afterIid: The global ID of a project’s issue that should be placed before this issue
        /// - Returns: no response.
        public func reorder(_ iid: Int,
                            inProject project: DataTypes.ProjectID,
                            beforeIid: Int? = nil,
                            afterIid: Int? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "move_before_id", beforeIid),
                APIOption(key: "move_after_id", afterIid)
            ])
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.Issues.reorder, options: options))
        }
        
        /// Moves an issue to a different project.
        ///
        /// If the target project is the source project or the user has insufficient permissions,
        /// an error message with status code 400 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#move-an-issue).
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - destProject: The ID of the new project
        /// - Returns: no response.
        public func move(_ iid: Int,
                         fromProject project: DataTypes.ProjectID,
                         toProject destProject: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "to_project_id", destProject)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.move, options: options))
        }
        
        
        /// Clone the issue to given project.
        /// If the user has insufficient permissions, an error message with status code 400 is returned.
        /// Copies as much data as possible as long as the target project contains equivalent
        /// criteria such as labels or milestones.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#clone-an-issue)
        ///
        /// - Parameters:
        ///   - iid: Internal ID of a project’s issue.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - destProject: ID of the new project.
        ///   - withNotes: Clone the issue with notes.
        /// - Returns: new cloned issue
        public func clone(_ iid: Int,
                          fromProject project: DataTypes.ProjectID,
                          toProject destProject: DataTypes.ProjectID,
                          withNotes: Bool? = nil) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "to_project_id", destProject),
                APIOption(key: "with_notes", withNotes)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.clone, options: options))
        }
        
        /// Subscribes the authenticated user to an issue to receive notifications.
        /// If the user is already subscribed to the issue, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#subscribe-to-an-issue)
        ///
        /// - Parameters:
        ///   - iid: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - project: The internal ID of a project’s issue
        /// - Returns: subscribed issue
        public func subscribe(_ iid: Int,
                              ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from the issue to not receive notifications from it.
        /// If the user is not subscribed to the issue, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#unsubscribe-from-an-issue).
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: unbscribed issue
        public func unsubscribe(_ iid: Int,
                                ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.unsubscribe, options: options))
        }
        
        /// Manually creates a to-do item for the current user on an issue.
        /// If there already exists a to-do item for the user on that issue, status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#create-a-to-do-item)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: issue
        public func createToDoItem(forIssue iid: Int,
                                   ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Issue> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.todo, options: options))
        }
        
        /// Promotes an issue to an epic by adding a comment.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#promote-an-issue-to-an-epic)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - note: The content of a note. Must contain `/promote` at the start of a new line.
        /// - Returns: note.
        public func promoteToEpic(_ iid: Int,
                                  ofProject project: DataTypes.ProjectID,
                                  note: String) async throws -> GitLabResponse<Model.Note> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "body", note)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.notes, options: options))
        }
        
        /// Sets an estimated time of work for this issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#set-a-time-estimate-for-an-issue)
        ///
        /// - Parameters:
        ///   - duration: duration expressed in seconds.
        ///   - iid: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - project: The internal ID of a project’s issue
        /// - Returns: estimate stat
        public func setEstimate(_ duration: TimeInterval,
                                forIssue iid: Int,
                                ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "duration", formatter.string(from: duration)!)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.timeEstimate, options: options))
        }
        
        /// Resets the estimated time for this issue to 0 seconds.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reset-the-time-estimate-for-an-issue)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: estimate stat
        public func resetEstimate(forIssue iid: Int,
                                  ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.TimeStats> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.resetTimeEstimate, options: options))
        }
        
        /// Adds spent time for this issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#add-spent-time-for-an-issue).
        ///
        /// - Parameters:
        ///   - duration: duration expressed in seconds.
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - summary: optional summary of how the time was spent.
        /// - Returns: spent time stat
        public func setSpentTime(_ duration: TimeInterval,
                                 forIssue iid: Int,
                                 ofProject project: DataTypes.ProjectID,
                                 summary: String? = nil) async throws -> GitLabResponse<Model.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid),
                APIOption(key: "duration", formatter.string(from: duration)!),
                APIOption(key: "summary", summary)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.addSpentTime, options: options))
        }
        
        /// Resets the total spent time for this issue to 0 seconds.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reset-spent-time-for-an-issue)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: spent time stat.
        public func resetSpentTime(forIssue iid: Int,
                                   ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.TimeStats> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Issues.resetSpentTime, options: options))
        }
        
        /// Get time tracking stats.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#get-time-tracking-stats)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: time stat.
        public func getTimeTracking(forIssue iid: Int,
                                    ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.TimeStats> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.timeStats, options: options))
        }
        
        /// Get all the merge requests that are related to the issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-merge-requests-related-to-issue)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: list of merge requests linked to the issue
        public func mergeRequests(forIssue iid: Int,
                                  ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.MergeRequest]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.relatedMergeRequests, options: options))
        }
        
        /// Get all merge requests that close a particular issue when merged.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-merge-requests-that-close-a-particular-issue-on-merge).
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: merge requests
        public func mergeRequests(closeIssue iid: Int,
                                  ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.MergeRequest]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.closedBy, options: options))
        }
        
        /// Participants on issues.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#participants-on-issues).
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: list of users
        public func participantsOn(_ iid: Int,
                                 ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.User]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.participants, options: options))
        }
        
        // MARK: - Comments on issue
        // <https://docs.gitlab.com/ee/api/issues.html#comments-on-issues>
        
        /// Get user agent details.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#get-user-agent-details).
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: agent detail
        public func userAgentsDetails(_ iid: Int,
                                      ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.UserAgentDetail> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", iid)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Issues.userAgentDetail, options: options))
        }
        
        // MARK: - List issue state events
        // <https://docs.gitlab.com/ee/api/issues.html#list-issue-state-events>
        
        // TODO: API Not Implemented
        // - https://docs.gitlab.com/ee/api/issues.html#upload-metric-image
        // - https://docs.gitlab.com/ee/api/issues.html#list-metric-images
        // - https://docs.gitlab.com/ee/api/issues.html#delete-metric-image
        
    }
    
}
