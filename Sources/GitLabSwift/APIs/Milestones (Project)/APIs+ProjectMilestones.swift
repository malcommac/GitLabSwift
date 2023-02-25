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

// MARK: ProjectMilestones + URLs

extension APIs.ProjectMilestones {
    
    fileprivate enum URLs: String, GLEndpoint {
        case milestones = "/projects/{id}/milestones"
        case milestone_id = "/projects/{id}/milestones/{milestone_id}"
        case issues = "/projects/{id}/milestones/{milestone_id}/issues"
        case merge_requests = "/projects/{id}/milestones/{milestone_id}/merge_requests"
        case promote = "/projects/{id}/milestones/{milestone_id}/promote"

        public var value: String { rawValue }
    }
    
}

//MARK: - ProjectMilestones + APIs

extension APIs {
    
    /// Project milestones API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/milestones.html#get-all-burndown-chart-events-for-a-single-milestone
    public class ProjectMilestones: APIs {
  
        /// Return all visible projects across GitLab for the authenticated user.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#list-project-milestones)
        ///
        /// - Returns: list of projects.
        public func list(project: InputParams.Project,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Milestone]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.milestones, options: options))
        }
        
        /// Gets a single project milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-single-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: milestone object.
        public func get(milestone: Int,
                        project: InputParams.Project) async throws -> GLResponse<GLModel.Milestone> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.milestone_id, options: options))
        }
        
        /// Creates a new project milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#create-new-milestone).
        ///
        /// - Parameters:
        ///   - title: The title of a milestone.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: created milestone object.
        public func create(title: String,
                           project: InputParams.Project,
                           options: @escaping ((CreateOptions) -> Void)) async throws -> GLResponse<GLModel.Milestone> {
            let options = CreateOptions(project: project, title: title, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.milestones, options: options))
        }
        
        /// Updates an existing project milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#delete-project-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: edited milestone
        public func edit(milestone: String,
                         project: InputParams.Project,
                         options: @escaping ((EditOptions) -> Void)) async throws -> GLResponse<GLModel.Milestone> {
            let options = EditOptions(milestone: milestone, project: project, options)
            return try await gitlab.execute(.init(.put, endpoint: URLs.milestone_id, options: options))
        }
        
        /// Delete project milestone.
        /// Only for users with at least the Reporter role in the project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#delete-project-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func delete(milestone: String,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.milestone_id, options: options))
        }
        
        /// Gets all issues assigned to a single project milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-all-issues-assigned-to-a-single-milestone)
        /// 
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: array of `Models.Issue`
        public func issuesAssignedTo(milestone: Int,
                                     project: InputParams.Project) async throws -> GLResponse<[GLModel.Issue]> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.issues, options: options))
        }
        
        /// Get all merge requests assigned to a single milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-all-merge-requests-assigned-to-a-single-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.MergeRequest`
        public func mergeRequestsAssignedTo(milestone: Int,
                                            project: InputParams.Project) async throws -> GLResponse<[GLModel.MergeRequest]> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.merge_requests, options: options))
        }
        
        /// Promote project milestone to a group milestone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#promote-project-milestone-to-a-group-milestone)
        ///
        /// - Parameters:
        ///   - milestone: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response.
        public func promoteToGroupMilestone(_ milestone: Int,
                                            project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "milestone_id", milestone),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.promote, options: options))
        }
        
    }
    
}
