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

// MARK: - Labels + URLs

extension APIs.MergeRequests {
    
    fileprivate enum URLs: String, GLEndpoint {
        case merge_requests = "/merge_requests"
        case merge_requests_project = "/projects/{id}/merge_requests"
        case merge_request_iid = "/projects/{id}/merge_requests/{merge_request_iid}"
        case partecipants = "/projects/{id}/merge_requests/{merge_request_iid}/participants"
        case reviewers = "/projects/{id}/merge_requests/{merge_request_iid}/reviewers"
        case commits = "/projects/{id}/merge_requests/{merge_request_iid}/commits"
        case diffs = "/projects/{id}/merge_requests/{merge_request_iid}/diffs"
        case pipelines = "/projects/{id}/merge_requests/{merge_request_iid}/pipelines"
        case merge = "/projects/{id}/merge_requests/{merge_request_iid}/merge"
        case cancel_merge = "/projects/{id}/merge_requests/{merge_request_iid}/cancel_merge_when_pipeline_succeeds"
        case rebase = "/projects/{id}/merge_requests/{merge_request_iid}/rebase"
        case resetApprovals = "/projects/{id}/merge_requests/{merge_request_iid}/reset_approvals"
        case close_issues = "/projects/{id}/merge_requests/{merge_request_iid}/closes_issues"
        case subscribe = "/projects/{id}/merge_requests/{merge_request_iid}/subscribe"
        case unsubscribe = "/projects/{id}/merge_requests/{merge_request_iid}/unsubscribe"
        case time_estimate = "/projects/{id}/merge_requests/{merge_request_iid}/time_estimate"
        case reset_time_estimate = "/projects/{id}/merge_requests/{merge_request_iid}/reset_time_estimate"
        case add_spent_time = "/projects/{id}/merge_requests/{merge_request_iid}/add_spent_time"
        case reset_spent_time = "/projects/{id}/merge_requests/{merge_request_iid}/reset_spent_time"
        case time_stats = "/projects/{id}/merge_requests/{merge_request_iid}/time_stats"
        case approvals = "/projects/{id}/merge_requests/{merge_request_iid}/approvals"

        public var value: String { rawValue }
    }
    
}

// MARK: - Labels + APIs

extension APIs {
    
    /// Merge Requests API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/merge_requests.html#get-single-merge-request-changes
    /// - https://docs.gitlab.com/ee/api/merge_requests.html#merge-to-default-merge-ref-path
    /// - https://docs.gitlab.com/ee/api/merge_requests.html#create-a-to-do-item
    /// - https://docs.gitlab.com/ee/api/merge_requests.html#get-merge-request-diff-versions
    /// - https://docs.gitlab.com/ee/api/merge_requests.html#get-a-single-merge-request-diff-version
    ///
    public class MergeRequests: APIs {
        
        /// Get all merge requests the authenticated user has access to.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-requests)
        ///
        /// - Parameters:
        ///   - project: project reference.
        ///   - options: options.
        /// - Returns: found merge requests.
        public func list(options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.MergeRequest]> {
            let options = ListOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.merge_requests, options: options))
        }
        
        /// Get all merge requests for this project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests)
        ///
        /// - Parameters:
        ///   - project: project (if any). Otherwise list is global.
        ///   - options: options.
        /// - Returns: found merge requests.
        public func list(project: InputParams.Project?,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.MergeRequest]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: (project == nil ? URLs.merge_requests : URLs.merge_requests_project), options: options))
        }
        
        /// Get all merge requests for this group and its subgroups.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-group-merge-requests)
        ///
        /// - Parameters:
        ///   - group: group.
        ///   - options: options.
        /// - Returns: found merge requests.
        public func list(group: Int,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.MergeRequest]> {
            let options = ListOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.merge_requests, options: options))
        }
        
        
        /// Shows information about a single merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: options.
        /// - Returns: found merge request
        public func get(_ mergeRequest: Int,
                        project: InputParams.Project,
                        options: ((SingleMROption) -> Void)? = nil) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = SingleMROption(iid: mergeRequest, project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.merge_request_iid, options: options))
        }
        
        /// Get a list of merge request participants.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-merge-request-participants)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: users
        public func partecipants(_ mergeRequest: Int,
                                 project: InputParams.Project) async throws -> GLResponse<[GLModel.User]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.partecipants, options: options))
        }
        
        /// Return informations about the group’s approval rules for a merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_request_approvals.html)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: approval rules
        public func approvals(_ mergeRequest: Int,
                              project: InputParams.Project) async throws -> GLResponse<GLModel.MergeRequestApprovals> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.approvals, options: options))
        }
        
        /// Get a list of merge request reviewers.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-merge-request-reviewers)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: users
        public func reviewers(_ mergeRequest: Int,
                              project: InputParams.Project) async throws -> GLResponse<[GLModel.User]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.reviewers, options: options))
        }
        
        /// Get a list of merge request commits.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-merge-request-commits)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: found commits
        public func commits(_ mergeRequest: Int,
                            project: InputParams.Project) async throws -> GLResponse<[GLModel.Commit]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.commits, options: options))
        }
        
        /// List diffs of the files changed in a merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-request-diffs)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: found diff
        public func diffs(_ mergeRequest: Int,
                          project: InputParams.Project) async throws -> GLResponse<[GLModel.Diff]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.diffs, options: options))
        }
        
        /// Get a list of merge request pipelines.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-request-pipelines)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: found pipelines
        public func pipelines(_ mergeRequest: Int,
                              project: InputParams.Project) async throws -> GLResponse<[GLModel.Pipeline]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.pipelines, options: options))
        }
        
        /// Create a new pipeline for a merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#create-merge-request-pipeline)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: pipeline created
        public func createPipeline(mergeRequest: Int,
                                   project: InputParams.Project) async throws -> GLResponse<GLModel.Pipeline> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.pipelines, options: options))
        }
        
        /// Creates a new merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#create-mr)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: creation options.
        /// - Returns: created merge request
        public func create(project: InputParams.Project,
                           options: ((CreateMROptions) -> Void)? = nil) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = CreateMROptions(project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.merge_requests, options: options))
        }
        
        /// Updates an existing merge request. You can change the target branch, title, or even close the MR.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#update-mr)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: update options
        /// - Returns: updated merge reuest
        public func update(project: InputParams.Project,
                           options: ((CreateMROptions) -> Void)? = nil) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = CreateMROptions(project: project, options)
            return try await gitlab.execute(.init(.put, endpoint: URLs.merge_request_iid, options: options))
        }
        
        /// Deletes the merge request in question.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#delete-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: updated merge reuest
        public func delete(mergeRequest: Int,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.merge_request_iid, options: options))
        }
        
        /// Accept and merge changes submitted with merge request using this API.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: Merge options.
        /// - Returns: merged request
        public func merge(mergeRequest: Int,
                          project: InputParams.Project,
                          options: ((MergeMROptions) -> Void)? = nil) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = MergeMROptions(iid: mergeRequest, project: project, options)
            return try await gitlab.execute(.init(.put, endpoint: URLs.merge, options: options))
        }
        
        /// Cancel merge when pipeline succeeds.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#cancel-merge-when-pipeline-succeeds)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: cancelled merge request.
        public func cancelMergeWhenPipelineSucceded(mergeRequest: Int,
                                                    project: InputParams.Project) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.cancel_merge, options: options))
        }
        
        /// Automatically rebase the source_branch of the merge request against its target_branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#rebase-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - skipCI: Set to true to skip creating a CI pipeline.
        /// - Returns: generic response
        public func rebase(mergeRequest: Int,
                           project: InputParams.Project,
                           skipCI: Bool? = false) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.rebase, options: options))
        }
        
        /// Clear all approvals of merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#reset-approvals-of-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response.
        public func resetApprovalsOfMergeRequest(_ mergeRequest: Int,
                                                 project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.resetApprovals, options: options))
        }
        
        /// Get all the issues that would be closed by merging the provided merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#list-issues-that-close-on-merge)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: found issues.
        public func issuesThatClose(mergeRequest: Int,
                                    project: InputParams.Project) async throws -> GLResponse<[GLModel.Issue]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.close_issues, options: options))
        }
        
        /// Subscribes the authenticated user to a merge request to receive notification.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#subscribe-to-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: subscribed merge request.
        public func subscribe(mergeRequest: Int,
                              project: InputParams.Project) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from a merge request to not receive notifications from that merge request. I
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#unsubscribe-from-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: unsubscribed merge request.
        public func unsubscribe(mergeRequest: Int,
                              project: InputParams.Project) async throws -> GLResponse<GLModel.MergeRequest> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.subscribe, options: options))
        }
        
        /// Manually creates a to-do item for the current user on a merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#create-a-to-do-item)
        ///
        /// - Parameters:
        ///   - duration: duration expressed in seconds.
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: time estimate.
        public func setTimeEstimate(duration: TimeInterval,
                                    mergeRequest: Int,
                                    project: InputParams.Project) async throws -> GLResponse<GLModel.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest),
                OutputParam(key: "duration", formatter.string(from: duration)!)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.time_estimate, options: options))
        }
        
        /// Resets the estimated time for this merge request to 0 seconds.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#reset-the-time-estimate-for-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of a project’s merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: time estimate.
        public func resetTimeEstimate(mergeRequest: Int,
                                      project: InputParams.Project) async throws -> GLResponse<GLModel.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.reset_time_estimate, options: options))
        }
        
        /// Adds spent time for this merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#add-spent-time-for-a-merge-request)
        ///
        /// - Parameters:
        ///   - duration: The duration.
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: time stat.
        public func addSpentTime(duration: TimeInterval,
                                 mergeRequest: Int,
                                 project: InputParams.Project) async throws -> GLResponse<GLModel.TimeStats> {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .brief
            formatter.allowedUnits = [.day, .hour]
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest),
                OutputParam(key: "duration", formatter.string(from: duration)!)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.add_spent_time, options: options))
        }
        
        /// Resets the total spent time for this merge request to 0 seconds.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#reset-spent-time-for-a-merge-request)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of a project’s merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: time stat.
        public func resetSpentTime(mergeRequest: Int,
                                   project: InputParams.Project) async throws -> GLResponse<GLModel.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.reset_spent_time, options: options))
        }
        
        /// Get time tracking stats.
        ///
        /// [AèI Documentation](https://docs.gitlab.com/ee/api/merge_requests.html#get-time-tracking-stats)
        ///
        /// - Parameters:
        ///   - mergeRequest: The internal ID of the merge request.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: time stats.
        public func timeTrackingStat(mergeRequest: Int,
                                     project: InputParams.Project) async throws -> GLResponse<GLModel.TimeStats> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.time_stats, options: options))
        }
        
    }
    
}
