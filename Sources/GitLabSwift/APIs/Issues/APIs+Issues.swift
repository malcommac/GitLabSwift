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

// MARK: - Issues + URLs

extension APIService {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/issues"
        case list_groups = "/groups/{id}/issues"
        case list_projects = "/projects/{id}/issues"
        case get = "/issues/{id}"
        case get_in_project = "/projects/{id}/issues/{issue_iid}"
        case reorder = "/projects/{id}/issues/{issue_iid}/reorder"
        case move = "/projects/{id}/issues/{issue_iid}/move"
        case clone = "/projects/{id}/issues/{issue_iid}/clone"
        case subscribe = "/projects/{id}/issues/{issue_iid}/subscribe"
        case unsubscribe = "/projects/{id}/issues/{issue_iid}/unsubscribe"
        case todo = "/projects/{id}/issues/{issue_iid}/todo"
        case notes = "/projects/{id}/issues/{issue_iid}/notes"
        case time_estimate = "/projects/{id}/issues/{issue_iid}/time_estimate"
        case reset_time_estimate = "/projects/{id}/issues/{issue_iid}/reset_time_estimate"
        case add_spent_time = "/projects/{id}/issues/{issue_iid}/add_spent_time"
        case reset_spent_time = "/projects/{id}/issues/{issue_iid}/reset_spent_time"
        case time_stats = "/projects/{id}/issues/{issue_iid}/time_stats"
        case related_merge_requests = "/projects/{id}/issues/{issue_iid}/related_merge_requests"
        case closed_by = "/projects/{id}/issues/{issue_iid}/closed_by"
        case participants = "/projects/{id}/issues/{issue_iid}/participants"
        case user_agent_detail = "/projects/{id}/issues/{issue_iid}/user_agent_detail"

        public var value: String { rawValue }
    }
    
}

// MARK: - Issues + APIs

extension APIService {
    
    /// Issues API.
    /// 
    /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/issues.html#list-issue-state-events
    /// - https://docs.gitlab.com/ee/api/issues.html#upload-metric-image
    /// - https://docs.gitlab.com/ee/api/issues.html#list-metric-images
    /// - https://docs.gitlab.com/ee/api/issues.html#delete-metric-image
    
    public class Issues: APIService {
        
        /// Get all issues the authenticated user has access to.
        /// By default it returns only issues created by the current user.
        /// To get all issues, use parameter `scope=all`.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-issues)
        ///
        /// - Parameter options: options callback.
        /// - Returns: found issues.
        public func list(options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[Model.Issue]> {
            let options = ListOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Get a list of a group’s issues.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-group-issues)
        ///
        /// NOTE:
        /// If the group is private, credentials need to be provided for authorization.
        ///
        /// - Parameters:
        ///   - id: id of the group.
        ///   - options: options for configuration.
        /// - Returns: found issues.
        public func list(group: Int,
                         options: ((ListGroupOptions) -> Void)? = nil) async throws -> GLResponse<[Model.Issue]> {
            let options = ListGroupOptions(group: group, options)
            return try await gitlab.execute(.init(endpoint: URLs.list_groups, options: options))
        }
        
        /// Get a list of a project’s issues.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-project-issues)
        ///
        /// NOTE:
        /// If the group is private, credentials need to be provided for authorization.
        ///
        /// - Parameters:
        ///   - project: id of the project.
        ///   - callback: configuration callback.
        /// - Returns: found issues.
        public func list(project: InputParams.ProjectID,
                         options: ((ListProjectOptions) -> Void)? = nil) async throws -> GLResponse<[Model.Issue]> {
            let options = ListProjectOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.list_projects, options: options))
        }
        
        /// Get a single issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#single-issue)
        ///
        /// - Parameter issue: id of the issue to retrive.
        /// - Returns: found issue.
        public func get(issue: Int) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Get a single project issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#single-project-issue)
        ///
        /// - Parameters:
        ///   - iid: iid of the issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: found issue.
        public func get(issue: Int,
                        project: InputParams.ProjectID) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get_in_project, options: options))
        }
        
        /// Creates a new project issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#new-issue)
        ///
        /// - Parameters:
        ///   - title: title of the issue.
        ///   - project: parent project.
        ///   - callback: configuration callback.
        public func create(title: String,
                           inProject project: InputParams.ProjectID,
                           _ callback: ((CreateOptions) -> Void)? = nil) async throws -> GLResponse<Model.Issue> {
            let options = CreateOptions(title: title, project: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: URLs.list_projects, options: options))
        }
        
        /// Updates an existing project issue.
        /// This call is also used to mark an issue as closed.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#edit-issue)
        ///
        /// - Parameters:
        ///   - issue: iid of the issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callbaxck.
        /// - Returns: updated issue.
        public func edit(issue: Int,
                         project: InputParams.ProjectID,
                         options: ((EditOptions) -> Void)? = nil) async throws -> GLResponse<Model.Issue> {
            let options = EditOptions(issue: issue, project: project, options)
            return try await gitlab.execute(.init(.put, endpoint: URLs.list_projects, options: options))
        }
        
        /// Deletes an issue.
        /// Only for administrators and project owners.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#delete-an-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue
        ///   - project: Reference project.
        /// - Returns: no response.
        public func delete(issue: Int,
                           project: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.get_in_project, options: options))
        }
        
        /// Reorders an issue, you can see the results when sorting issues manually.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reorder-an-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of the project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        ///   - beforeID: The global ID of a project’s issue that should be placed after this issue
        ///   - afterID: The global ID of a project’s issue that should be placed before this issue
        /// - Returns: no response.
        public func reorder(issue: Int,
                            project: InputParams.ProjectID,
                            beforeID: Int? = nil,
                            afterID: Int? = nil) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "move_before_id", beforeID),
                OutputParam(key: "move_after_id", afterID)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.reorder, options: options))
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
        public func move(issue: Int,
                         project: InputParams.ProjectID,
                         to destProject: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "to_project_id", destProject)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.move, options: options))
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
        public func clone(issue: Int,
                          project: InputParams.ProjectID,
                          to destProject: InputParams.ProjectID,
                          notes: Bool? = nil) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "to_project_id", destProject),
                OutputParam(key: "with_notes", notes)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.clone, options: options))
        }
        
        /// Subscribes the authenticated user to an issue to receive notifications.
        /// If the user is already subscribed to the issue, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#subscribe-to-an-issue)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: subscribed issue.
        public func subscribe(issue: Int,
                              project: InputParams.ProjectID) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from the issue to not receive notifications from it.
        /// If the user is not subscribed to the issue, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#unsubscribe-from-an-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: unbscribed issue.
        public func unsubscribe(issue: Int,
                                project: InputParams.ProjectID) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.unsubscribe, options: options))
        }
        
        /// Manually creates a to-do item for the current user on an issue.
        /// If there already exists a to-do item for the user on that issue, status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#create-a-to-do-item)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: issue
        public func createToDo(issue: Int,
                               project: InputParams.ProjectID) async throws -> GLResponse<Model.Issue> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.todo, options: options))
        }
        
        /// Promotes an issue to an epic by adding a comment.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#promote-an-issue-to-an-epic)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - note: The content of a note. Must contain `/promote` at the start of a new line.
        /// - Returns: note.
        public func promoteToEpic(issue: Int,
                                  project: InputParams.ProjectID,
                                  note: String) async throws -> GLResponse<Model.Note> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "body", note)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.notes, options: options))
        }
        
        /// Sets an estimated time of work for this issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#set-a-time-estimate-for-an-issue)
        ///
        /// - Parameters:
        ///   - duration: duration expressed in seconds.
        ///   - issue: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - project: The internal ID of a project’s issue
        /// - Returns: estimate stat
        public func setEstimate(_ duration: TimeInterval,
                                issue: Int,
                                project: InputParams.ProjectID) async throws -> GLResponse<Model.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "duration", formatter.string(from: duration)!)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.time_estimate, options: options))
        }
        
        /// Resets the estimated time for this issue to 0 seconds.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reset-the-time-estimate-for-an-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: estimate stat
        public func resetEstimate(issue: Int,
                                  project: InputParams.ProjectID) async throws -> GLResponse<Model.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.reset_time_estimate, options: options))
        }
        
        /// Adds spent time for this issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#add-spent-time-for-an-issue)
        ///
        /// - Parameters:
        ///   - duration: duration expressed in seconds.
        ///   - issue: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        ///   - summary: optional summary of how the time was spent.
        /// - Returns: spent time stat
        public func setSpentTime(_ duration: TimeInterval,
                                 issue: Int,
                                 project: InputParams.ProjectID,
                                 summary: String? = nil) async throws -> GLResponse<Model.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "duration", formatter.string(from: duration)!),
                OutputParam(key: "summary", summary)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.add_spent_time, options: options))
        }
        
        /// Resets the total spent time for this issue to 0 seconds.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#reset-spent-time-for-an-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: spent time stat.
        public func resetSpentTime(issue: Int,
                                   project: InputParams.ProjectID) async throws -> GLResponse<Model.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.reset_spent_time, options: options))
        }
        
        /// Get time tracking stats.
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#get-time-tracking-stats)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: time stat.
        public func getTimeTracking(issue: Int,
                                    project: InputParams.ProjectID) async throws -> GLResponse<Model.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.time_stats, options: options))
        }
        
        /// Get all the merge requests that are related to the issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-merge-requests-related-to-issue)
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project’s issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: list of merge requests linked to the issue
        public func mergeRequestsForIssue(_ issue: Int,
                                          project: InputParams.ProjectID) async throws -> GLResponse<[Model.MergeRequest]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.related_merge_requests, options: options))
        }
        
        /// Get all merge requests that close a particular issue when merged.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#list-merge-requests-that-close-a-particular-issue-on-merge).
        ///
        /// - Parameters:
        ///   - issue: The internal ID of a project issue.
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: merge requests.
        public func mergeRequestsClosesIssue(_ issue: Int,
                                             project: InputParams.ProjectID) async throws -> GLResponse<[Model.MergeRequest]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.closed_by, options: options))
        }
        
        /// Participants on issues.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/issues.html#participants-on-issues)
        ///
        /// - Parameters:
        ///   - iid: The internal ID of a project’s issue
        ///   - project: The global ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: list of users
        public func participantsOnIssue(_ issue: Int,
                                        project: InputParams.ProjectID) async throws -> GLResponse<[Model.User]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.participants, options: options))
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
        public func userAgentsDetails(issue: Int,
                                      project: InputParams.ProjectID) async throws -> GLResponse<Model.UserAgentDetail> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.user_agent_detail, options: options))
        }
        
    }
    
}
