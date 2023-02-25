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

// MARK: - Repositories + URLs

extension APIService.Repositories {
    
    fileprivate enum URLs: String, GLEndpoint {
        case tree = "/projects/{id}/repository/tree"
        case blob = "/projects/{id}/repository/blobs/{sha}"
        case blob_raw = "/projects/{id}/repository/blobs/{sha}/raw"
        case archive = "/projects/{id}/repository/archive{format}"
        case compare = "/projects/{id}/repository/compare"
        case contributors = "/projects/{id}/repository/contributors"
        case merge_base = "/projects/{id}/repository/merge_base"
        case changelog = "/projects/{id}/repository/changelog"

        public var value: String { rawValue }
    }
    
}

// MARK: - Repositories + APIs

extension APIService {
    
    /// Repositories API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html)
    public class Repositories: APIService {
        
        /// Get a list of repository files and directories in a project.
        /// 
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#list-repository-tree)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: list of files and folders
        public func list(project: InputParams.ProjectID,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[Model.Repository.Tree]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.tree, options: options))
        }
        
        /// Allows you to receive information, such as size and content, about blobs in a repository.
        /// Blob content is Base64 encoded.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#get-a-blob-from-repository)
        ///
        /// - Parameters:
        ///   - sha: The blob SHA.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response
        public func blob(sha: String,
                         project: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.blob, options: options))
        }
        
        /// Get the raw file contents for a blob, by blob SHA.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#raw-blob-content)
        ///
        /// - Parameters:
        ///   - sha: The blob SHA.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response
        public func blobRaw(sha: String,
                            project: InputParams.ProjectID) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.blob_raw, options: options))
        }
        
        /// Get an archive of the repository.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#get-file-archive)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - path: The subpath of the repository to download. If an empty string, defaults to the whole repository.
        ///   - sha: The commit SHA to download.
        ///   - format: The commit SHA to download.
        /// - Returns: generic response
        public func fileArchive(project: InputParams.ProjectID,
                                path: String? = nil,
                                sha: String? = nil,
                                format: InputParams.ArchiveFormat = .zip) async throws -> GLResponse<Model.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha),
                OutputParam(key: "path", path)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.archive, options: options))
        }
        
        /// Compare branches, tags or commits.
        /// Diffs can have an empty diff string if diff limits are reached.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#compare-branches-tags-or-commits)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - fromSha: The commit SHA or branch name.
        ///   - compareProject: The ID to compare from.
        ///   - toSha: The commit SHA or branch name.
        ///   - straight: Comparison method.
        ///               - `true` for direct comparison between from and to `(from..to)`,
        ///               - `false` to compare using merge base `(from…to)`’.
        ///               Default is `false`.
        /// - Returns: diff
        public func compare(project: InputParams.ProjectID,
                            fromSha: String,
                            toProject compareProject: Int? = nil,
                            toSha: String,
                            straight: Bool? = nil) async throws -> GLResponse<Model.ShaCompareResult> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "from", fromSha),
                OutputParam(key: "to", toSha),
                OutputParam(key: "from_project_id", compareProject),
                OutputParam(key: "straight", straight)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.compare, options: options))
        }
        
        /// Get repository contributors list.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#contributors)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - orderBy: Return contributors ordered by `name`, `email`, or `commits` (orders by commit date) fields.
        ///   - sort: Return contributors sorted.
        /// - Returns: list of contributors
        public func contributors(project: InputParams.ProjectID,
                                 orderBy: InputParams.ContributorsOrder? = nil,
                                 sort: InputParams.Sort? = nil) async throws -> GLResponse<[Model.Contributor]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "order_by", orderBy),
                OutputParam(key: "sort", sort)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.contributors, options: options))
        }
        
        /// Get the common ancestor for 2 or more refs, such as commit SHAs, branch names, or tags.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#merge-base)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - refs: The refs to find the common ancestor of. Accepts multiple refs.
        /// - Returns: common ancestor info
        public func mergeBase(project: InputParams.ProjectID,
                              refs: [String]) async throws -> GLResponse<Model.CommonAncestor> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "refs", refs)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.merge_base, options: options))
        }
        
        /// Generate changelog data based on commits in a repository.
        ///
        /// - Parameters:
        ///   - version: The version to generate the changelog for. The format must follow semantic versioning.
        ///   - project: Referenced project.
        ///   - options: Configuration callback.
        public func addChangelog(version: String,
                                 project: InputParams.ProjectID,
                                 options: ((ChangelogOptions) -> Void)? = nil) async throws -> GLResponse<Model.NoResponse> {
            let options = ChangelogOptions(version: version, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.changelog, options: options))
        }
        
        /// Generate changelog data based on commits in a repository, without committing them to a changelog file.
        ///
        /// - Parameter callback: callback configuration.
        /// - Returns: changelog info.
        
        /// Generate changelog data based on commits in a repository, without committing them to a changelog file.
        ///
        /// - Parameters:
        ///   - version: The version to generate the changelog for. The format must follow semantic versioning.
        ///   - project: referenced project.
        ///   - callback: configuration callback.
        /// - Returns: changelog.
        public func generateChangelog(version: String,
                               project: InputParams.ProjectID,
                               options: ((NewChangelogOptions) -> Void)? = nil) async throws -> GLResponse<Model.Changelog> {
            let options = NewChangelogOptions(version: version, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.changelog, options: options))
        }
        
    }
    
}
