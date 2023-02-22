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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html)
    public class ProtectedBranches: APIService {
        
        /// Gets a list of protected branches from a project as they are defined in the UI.
        /// If a wildcard is set, it is returned instead of the exact name of the branches that match that wildcard.
        /// [Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches).
        ///
        /// - Parameters:
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - search: Name or part of the name of protected branches to be searched for
        /// - Returns: array of `Models.Branch`
        public func list(project: DataTypes.ProjectID,
                         search: DataTypes.Search? = nil) async throws -> GitLabResponse<[Model.ProtectedBranch]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Branches.protectedList, options: options))
        }
        
        /// Gets a single protected branch or wildcard protected branch.
        /// [Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#get-a-single-protected-branch-or-wildcard-protected-branch)
        ///
        /// - Parameters:
        ///   - name: The name of the branch or wildcard
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: `Models.ProtectedBranch`
        public func get(_ name: String,
                        project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.ProtectedBranch> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "branch", name)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Branches.detailProtected, options: options))
        }
        
        
        /// Protects a single repository branch or several project repository branches using a wildcard protected branch.
        /// [Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches)
        ///
        /// - Parameters:
        ///   - name: The name of the branch or wildcard
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: `Models.ProtectedBranch`
        public func protect(_ name: String,
                            project: DataTypes.ProjectID,
                            _ callback: @escaping ((APIOptions.ProtectBranch) -> Void)) async throws -> GitLabResponse<Model.ProtectedBranch> {
            let options = APIOptions.ProtectBranch(name: name, project: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Branches.protectedList, options: options))
        }
        
        /// Unprotects the given protected branch or wildcard protected branch.
        /// [Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches).
        ///
        /// - Parameters:
        ///   - name: The name of the branch
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        public func unprotect(_ name: String,
                              project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "branch", name)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Branches.detailProtected, options: options))
        }
        
        /// Updates a protected branch.
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#update-a-protected-branch)
        ///
        /// - Parameters:
        ///   - name: The name of the branch
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callbaxck.
        /// - Returns: updated protected branch
        public func update(_ name: String,
                           project: DataTypes.ProjectID,
                           _ callback: @escaping ((APIOptions.ProtectBranch) -> Void)) async throws -> GitLabResponse<Model.ProtectedBranch> {
            let options = APIOptions.ProtectBranch(name: name, project: project, callback)
            return try await gitlab.execute(.init(.patch, endpoint: Endpoints.Branches.detailProtected, options: options))
        }
        
    }
    
}
