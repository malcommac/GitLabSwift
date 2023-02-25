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

// MARK: - GroupMilestones + URLs

extension APIService.GroupMilestones {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/groups/{id}/milestones"
        case get = "/groups/{id}/milestones/{milestone_id}"
        case issues = "/groups/{id}/milestones/{milestone_id}/issues"
        case mergeRequests = "/groups/{id}/milestones/{milestone_id}/merge_requests"

        public var value: String { rawValue }
    }
    
}

// MARK: - GroupMilestones + APIs

extension APIService {
    
    /// Group milestones API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/group_milestones.html#get-all-burndown-chart-events-for-a-single-milestone
    public class GroupMilestones: APIService {
        
        /// Returns a list of group milestones.
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#list-group-milestones)
        ///
        /// - Parameters:
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: milestones.
        public func list(group: Int,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[Model.Milestone]> {
            let options = ListOptions(group: group, options)
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Gets a single group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#get-single-milestone)
        ///
        /// - Parameters:
        ///   - id: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - group: The ID of the group milestone
        /// - Returns: milestone
        public func get(milestone: Int,
                        group: Int) async throws -> GLResponse<Model.Milestone> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", group)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Creates a new group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#create-new-milestone)
        ///
        /// - Parameters:
        ///   - title: The title of a milestone.
        ///   - description: The description of the milestone.
        ///   - due: The due date of the milestone.
        ///   - start: The start date of the milestone.
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user.
        /// - Returns: created milestone.
        public func create(title: String,
                           description: String? = nil,
                           due: Date? = nil,
                           start: Date? = nil,
                           group: Int) async throws -> GLResponse<Model.Milestone> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "title", title),
                OutputParam(key: "description", description),
                OutputParam(key: "due_date", due),
                OutputParam(key: "start_date", start)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Updates an existing group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#edit-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of a group milestone
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - title: The title of a milestone
        ///   - description: The description of a milestone
        ///   - due: The due date of the milestone
        ///   - start: The start date of the milestone
        ///   - state: The state event of the milestone
        /// - Returns: updated milestone
        public func edit(milestone: Int,
                         group: Int,
                         title: String? = nil,
                         description: String? = nil,
                         due: Date? = nil,
                         start: Date? = nil,
                         state: InputParams.MilestoneState? = nil) async throws -> GLResponse<Model.Milestone> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "title", title),
                OutputParam(key: "description", description),
                OutputParam(key: "due_date", due),
                OutputParam(key: "start_date", start),
                OutputParam(key: "state_event", state)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.get, options: options))
        }
        
        /// Delete group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#delete-group-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the group’s milestone
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: no response
        public func delete(milestone: Int,
                           group: Int) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "milestone_id", milestone)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.get, options: options))
        }
        
        /// Gets all issues assigned to a single group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#get-all-issues-assigned-to-a-single-milestone)
        /// 
        /// - Parameters:
        ///   - milestone: The ID of a group milestone.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user.
        /// - Returns: issues of the milestone (note: it doesn’t return issues from any subgroups)
        public func issuesAssignedTo(milestone: Int,
                                     group: Int) async throws -> GLResponse<[Model.Issue]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "milestone_id", milestone)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.issues, options: options))
        }
        
        /// Gets all merge requests assigned to a single group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_milestones.html#get-all-merge-requests-assigned-to-a-single-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of a group milestone.
        ///   - project: The ID or URL-encoded path of the group owned by the authenticated user.
        /// - Returns: list of merge requests.
        public func mergeRequestsAssignedTo(milestone: Int,
                                            group: Int) async throws -> GLResponse<[Model.MergeRequest]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "milestone_id", milestone)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.mergeRequests, options: options))
        }
  
    }
    
}
