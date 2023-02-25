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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/branches.html)
    public class Branches: APIService {
                
        /// Get a list of repository branches from a project, sorted by name alphabetically.
        /// [Documentation](https://docs.gitlab.com/ee/api/branches.html#list-repository-branches).
        ///
        /// - Parameters:
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - search: Return list of branches containing the search string.
        /// - Returns: array of `Models.Branch`
        public func list(project id: DataTypes.ProjectID,
                         search: DataTypes.Search? = nil) async throws -> GitLabResponse<[Model.Branch]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id),
                APIOption(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Branches.list, options: options))
        }
        
        /// Get a single project repository branch.
        /// [Documentation](https://docs.gitlab.com/ee/api/branches.html#get-single-repository-branch).
        ///
        /// - Parameters:
        ///   - name: name of the branch.
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: `Models.Branch`
        public func get(_ name: String,
                        project id: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Branch> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id),
                APIOption(key: "branch", name)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Branches.detail, options: options))
        }
    
        /// Create a new branch in the repository.
        ///
        /// - Parameters:
        ///   - name: Name of the branch.
        ///   - ref: Branch name or commit SHA to create branch from.
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: Branch
        public func create(name: String,
                           fromRef ref: String,
                           project id: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Branch> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id),
                APIOption(key: "branch", name),
                APIOption(key: "ref", ref)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Branches.list, options: options))
        }
        
        /// Delete a branch from the repository.
        ///
        /// - Parameters:
        ///   - name: name of the branch to remove.
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        public func delete(name: String,
                           project id: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id),
                APIOption(key: "branch", name),
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Branches.detail, options: options))
        }
        
        /// Deletes all branches that are merged into the project’s default branch.
        /// NOTE: Protected branches are not deleted as part of this operation.
        ///
        /// - Parameter id: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response
        public func deleteMergedBranches(project id: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Branches.mergedBranches, options: options))
        }
        
    }
    
}
