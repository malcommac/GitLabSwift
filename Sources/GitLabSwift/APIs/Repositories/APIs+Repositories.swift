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
        public func list(project: DataTypes.ProjectID,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GitLabResponse<[Model.Repository.Tree]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.tree, options: options))
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
                         project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.blob, options: options))
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
                            project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.blobRaw, options: options))
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
        public func fileArchive(project: DataTypes.ProjectID,
                                path: String? = nil,
                                sha: String? = nil,
                                format: DataTypes.ArchiveFormat = .zip) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "sha", sha),
                APIOption(key: "path", path)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.archive, options: options))
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
        public func compare(project: DataTypes.ProjectID,
                            fromSha: String,
                            toProject compareProject: Int? = nil,
                            toSha: String,
                            straight: Bool? = nil) async throws -> GitLabResponse<Model.ShaCompareResult> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "from", fromSha),
                APIOption(key: "to", toSha),
                APIOption(key: "from_project_id", compareProject),
                APIOption(key: "straight", straight)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.compare, options: options))
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
        public func contributors(project: DataTypes.ProjectID,
                                 orderBy: DataTypes.ContributorsOrder? = nil,
                                 sort: DataTypes.Sort? = nil) async throws -> GitLabResponse<[Model.Contributor]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "order_by", orderBy),
                APIOption(key: "sort", sort)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.contributors, options: options))
        }
        
        /// Get the common ancestor for 2 or more refs, such as commit SHAs, branch names, or tags.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repositories.html#merge-base)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - refs: The refs to find the common ancestor of. Accepts multiple refs.
        /// - Returns: common ancestor info
        public func mergeBase(project: DataTypes.ProjectID,
                              refs: [String]) async throws -> GitLabResponse<Model.CommonAncestor> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "refs", refs)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Repositories.mergeBase, options: options))
        }
        
        /// Generate changelog data based on commits in a repository.
        ///
        /// - Parameters:
        ///   - version: The version to generate the changelog for. The format must follow semantic versioning.
        ///   - project: Referenced project.
        ///   - options: Configuration callback.
        public func addChangelog(version: String,
                                 project: DataTypes.ProjectID,
                                 options: ((ChangelogOptions) -> Void)? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = ChangelogOptions(version: version, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Repositories.changelog, options: options))
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
                               project: DataTypes.ProjectID,
                               options: ((NewChangelogOptions) -> Void)? = nil) async throws -> GitLabResponse<Model.Changelog> {
            let options = NewChangelogOptions(version: version, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Repositories.changelog, options: options))
        }
        
    }
    
}
