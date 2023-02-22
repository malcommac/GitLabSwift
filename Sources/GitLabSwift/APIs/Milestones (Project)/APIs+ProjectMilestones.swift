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
    
    public class ProjectMilestones: APIService {
  
        /// Return all visible projects across GitLab for the authenticated user.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#list-project-milestones).
        ///
        /// - Returns: list of projects.
        public func list(id: DataTypes.ProjectID, _ callback: ((APIOptions.ListMilestones) -> Void)? = nil) async throws -> GitLabResponse<[Model.Milestone]> {
            let options = APIOptions.ListMilestones(callback)
            options.projectID = id
            return try await gitlab.execute(.init(endpoint: Endpoints.Milestones.milestones, options: options))
        }
        
        /// Gets a single project milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-single-milestone).
        ///
        /// - Parameters:
        ///   - id: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: milestone object
        public func detail(id: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Milestone> {
            let options = APIOptionsCollection([
                APIOption(key: "milestone_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Milestones.milestoneId, options: options))
        }
        
        /// Creates a new project milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#create-new-milestone).
        ///
        /// - Parameters:
        ///   - title: The title of a milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: created milestone object.
        public func create(title: String, project: DataTypes.ProjectID, _ callback: @escaping ((APIOptions.CreateMilestone) -> Void)) async throws -> GitLabResponse<Model.Milestone> {
            let options = APIOptions.CreateMilestone(projectID: project, title: title, callback)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Milestones.milestones, options: options))
        }
        
        /// Updates an existing project milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#delete-project-milestone).
        ///
        /// - Parameters:
        ///   - id: The ID of the project’s milestone.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback.
        /// - Returns: edited milestone
        public func edit(id: String, project: DataTypes.ProjectID, _ callback: @escaping ((APIOptions.EditMilestone) -> Void)) async throws -> GitLabResponse<Model.Milestone> {
            let options = APIOptions.EditMilestone(milestoneId: id, projectID: project, callback)
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.Milestones.milestoneId, options: options))
        }
        
        /// Delete project milestone.
        /// Only for users with at least the Reporter role in the project.
        ///
        /// - Parameters:
        ///   - id: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func delete(id: String, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "milestone_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Milestones.milestoneId, options: options))
        }
        
        /// Gets all issues assigned to a single project milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-all-issues-assigned-to-a-single-milestone).
        /// 
        /// - Parameters:
        ///   - id: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.Issue`
        public func issues(id: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Issue]> {
            let options = APIOptionsCollection([
                APIOption(key: "milestone_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Milestones.issues, options: options))
        }
        
        /// Get all merge requests assigned to a single milestone
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#get-all-merge-requests-assigned-to-a-single-milestone).
        ///
        /// - Parameters:
        ///   - id: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.MergeRequest`
        public func mergeRequests(id: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.MergeRequest]> {
            let options = APIOptionsCollection([
                APIOption(key: "milestone_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Milestones.mergeRequests, options: options))
        }
        
        /// Promote project milestone to a group milestone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/milestones.html#promote-project-milestone-to-a-group-milestone).
        ///
        /// - Parameters:
        ///   - id: The ID of the project’s milestone
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response.
        public func promoteToGroupMilestone(id: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "milestone_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Milestones.promote, options: options))
        }
        
    }
    
}
