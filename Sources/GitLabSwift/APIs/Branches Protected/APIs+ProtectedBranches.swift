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

// MARK: - Protected Branches + URLs

extension APIs.ProtectedBranches {
    
    fileprivate enum URLs: String, GLEndpoint {
        case protectedList = "/projects/{id}/protected_branches"
        case detailProtected = "/projects/{id}/protected_branches/{branch}"

        public var value: String { rawValue }
    }
    
}

// MARK: - Protected Branches + APIs

extension APIs {
    
    /// Protected branches API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html)
    public class ProtectedBranches: APIs {
        
        /// Gets a list of protected branches from a project as they are defined in the UI.
        /// If a wildcard is set, it is returned instead of the exact name of the branches that match that wildcard.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches).
        ///
        /// - Parameters:
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - search: Name or part of the name of protected branches to be searched for
        /// - Returns: array of `Models.Branch`
        public func list(project: InputParams.Project,
                         search: InputParams.Search? = nil) async throws -> GLResponse<[GLModel.ProtectedBranch]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.protectedList, options: options))
        }
        
        /// Gets a single protected branch or wildcard protected branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#get-a-single-protected-branch-or-wildcard-protected-branch)
        ///
        /// - Parameters:
        ///   - name: The name of the branch or wildcard
        ///   - id: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: `Models.ProtectedBranch`
        public func get(_ name: String,
                        project: InputParams.Project) async throws -> GLResponse<GLModel.ProtectedBranch> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "branch", name)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.detailProtected, options: options))
        }
        
        
        /// Protects a single repository branch or several project repository branches using a wildcard protected branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches)
        ///
        /// - Parameters:
        ///   - name: The name of the branch or wildcard
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: Configuration options.
        /// - Returns: protected branch.
        public func protect(_ name: String,
                            project: InputParams.Project,
                            options: @escaping ((ProtectBranchOptions) -> Void)) async throws -> GLResponse<GLModel.ProtectedBranch> {
            let options = ProtectBranchOptions(name: name, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.protectedList, options: options))
        }
        
        /// Unprotects the given protected branch or wildcard protected branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches).
        ///
        /// - Parameters:
        ///   - name: The name of the branch
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user.
        public func unprotect(_ name: String,
                              project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "branch", name)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.detailProtected, options: options))
        }
        
        /// Updates a protected branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/protected_branches.html#update-a-protected-branch)
        ///
        /// - Parameters:
        ///   - name: The name of the branch
        ///   - id: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: Configuration options.
        /// - Returns: updated protected branch
        public func update(_ name: String,
                           project: InputParams.Project,
                           options: @escaping ((UpdateBranchOptions) -> Void)) async throws -> GLResponse<GLModel.ProtectedBranch> {
            let options = UpdateBranchOptions(name: name, project: project, options)
            return try await gitlab.execute(.init(.patch, endpoint: URLs.detailProtected, options: options))
        }
        
    }
    
}
