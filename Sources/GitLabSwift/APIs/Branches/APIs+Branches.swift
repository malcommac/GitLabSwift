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

// MARK: - Branches + URLs

extension APIService.Branches {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/projects/{id}/repository/branches"
        case detail = "/projects/{id}/repository/branches/{branch}"
        case merged_branches = "/projects/{id}/repository/merged_branches"

        public var value: String { rawValue }
    }
    
}

// MARK: - Branches + APIs

extension APIService {
    
    /// Branches API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/branches.html)
    public class Branches: APIService {
                
        /// Get a list of repository branches from a project, sorted by name alphabetically.
        /// [Documentation](https://docs.gitlab.com/ee/api/branches.html#list-repository-branches).
        ///
        /// - Parameters:
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - search: Return list of branches containing the search string.
        /// - Returns: array of `Models.Branch`
        public func list(project id: InputParams.ProjectID,
                         search: InputParams.Search? = nil) async throws -> GLResponse<[Model.Branch]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id),
                OutputParam(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Get a single project repository branch.
        /// [Documentation](https://docs.gitlab.com/ee/api/branches.html#get-single-repository-branch).
        ///
        /// - Parameters:
        ///   - name: name of the branch.
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: `Models.Branch`
        public func get(_ name: String,
                        project id: InputParams.ProjectID) async throws -> GLResponse<Model.Branch> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id),
                OutputParam(key: "branch", name)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.detail, options: options))
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
                           project id: InputParams.ProjectID) async throws -> GLResponse<Model.Branch> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id),
                OutputParam(key: "branch", name),
                OutputParam(key: "ref", ref)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.list, options: options))
        }
        
        /// Delete a branch from the repository.
        ///
        /// - Parameters:
        ///   - name: name of the branch to remove.
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        public func delete(name: String,
                           project id: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id),
                OutputParam(key: "branch", name),
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.detail, options: options))
        }
        
        /// Deletes all branches that are merged into the project’s default branch.
        /// NOTE: Protected branches are not deleted as part of this operation.
        ///
        /// - Parameter id: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response
        public func deleteMergedBranches(project id: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.merged_branches, options: options))
        }
        
    }
    
}
