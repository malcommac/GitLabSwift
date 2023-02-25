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

// MARK: - Commits + URLs

extension APIs.Commits {
    
    fileprivate enum URLs: String, GLEndpoint {
        case commits = "/projects/{id}/repository/commits"
        case detail = "/projects/{id}/repository/commits/{sha}"
        case diff = "/projects/{id}/repository/commits/{sha}/diff"
        case comments = "/projects/{id}/repository/commits/{sha}/comments"
        case ref = "/projects/{id}/repository/commits/{sha}/refs"
        case discussions = "/projects/{id}/repository/commits/{sha}/discussions"
        case statuses = "/projects/{id}/repository/commits/{sha}/statuses"
        case mr = "/projects/{id}/repository/commits/{sha}/merge_requests"
        case gpg = "/projects/{id}/repository/commits/{sha}/signature"
        case cherryPick = "/projects/{id}/repository/commits/{sha}/cherry_pick"
        case revert = "/projects/{id}/repository/commits/{sha}/revert"

        public var value: String { rawValue }
    }
    
}

// MARK: - Commits + APIs

extension APIs {
    
    /// This API operates on repository commits. Read more about GitLab-specific information for commits.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions
    /// - https://docs.gitlab.com/ee/api/commits.html#set-the-pipeline-status-of-a-commit
    public class Commits: APIs {
        
        /// Get a list of repository commits in a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#list-repository-commits).
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: configuratin callback.
        /// - Returns: array of `Models.Commits`
        public func list(project: InputParams.Project,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Commit]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.commits, options: options))
        }
        
        /// Get a specific commit identified by the commit hash or name of a branch or tag.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-a-single-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - stats: Include commit stats. Default is `true`.
        public func get(sha: String,
                        project: InputParams.Project,
                        stats: Bool = false)
            async throws -> GLResponse<GLModel.Commit> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha),
                OutputParam(key: "stats", stats)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.detail, options: options))
        }
        
        /// Get all references (from `branches` or `tags`) a commit is pushed to.
        /// The pagination parameters page and per_page can be used to restrict the list of references.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-references-a-commit-is-pushed-to).
        ///
        /// - Parameters:
        ///   - sha: The commit hash.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - type: The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`.
        /// - Returns: array of `Models.Commit.Ref`.
        public func ref(sha: String,
                        project: InputParams.Project,
                        type: InputParams.CommitRefType? = nil) async throws -> GLResponse<[GLModel.Commit.Ref]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha),
                OutputParam(key: "type", type)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.ref, options: options))
        }
        
        /// Cherry-picks a commit to a given branch.
        /// 
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#cherry-pick-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash
        ///   - branch: The name of the branch
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback.
        /// - Returns: `Models.Commit`
        public func cherryPick(sha: String,
                               branch: String,
                               project: InputParams.Project,
                               callback: ((CherryPickOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.Commit> {
            let options = CherryPickOptions(sha: sha, branch: branch, project: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: URLs.cherryPick, options: options))
        }
        
        /// Reverts a commit in a given branch.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#revert-a-commit).
        ///
        /// - Parameters:
        ///   - sha: Commit SHA to revert
        ///   - branch: Target branch name
        ///   - project: The ID or URL-encoded path of the project
        ///   - dryRun: Does not commit any changes. Default is false. Introduced in GitLab 13.3
        /// - Returns: `Models.Commit`
        public func revert(sha: String,
                           branch: String,
                           project: InputParams.Project,
                           dryRun: Bool? = nil) async throws -> GLResponse<GLModel.Commit> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha),
                OutputParam(key: "branch", branch),
                OutputParam(key: "dry_run", dryRun)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.revert, options: options))
        }
        
        /// Get the diff of a commit in a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-the-diff-of-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: differences in commit.
        public func diff(sha: String,
                         project: InputParams.Project) async throws -> GLResponse<[GLModel.Commit.Diff]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.diff, options: options))
        }
        
        /// Get the comments of a commit in a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-the-comments-of-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.Commit.Comment`
        public func comments(sha: String,
                             project: InputParams.Project) async throws -> GLResponse<[GLModel.Commit.Comment]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.comments, options: options))
        }
        
        /// Adds a comment to a commit.
        /// To post a comment in a particular line of a particular file, you must specify the full commit SHA,
        /// the path, the line, and line_type should be new.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#post-comment-to-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit SHA or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: Configure options callback.
        /// - Returns: `Models.Commit.Comment`
        public func postComment(sha: String, project: InputParams.Project,
                                options: @escaping ((PostCommentOptions) -> Void)) async throws -> GLResponse<GLModel.Commit.Comment> {
            let options = PostCommentOptions(sha: sha, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.comments, options: options))
        }
        
        /// Get all references (from branches or tags) a commit is pushed to.
        /// The pagination parameters page and per_page can be used to restrict the list of references.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-references-a-commit-is-pushed-to).
        ///
        /// - Parameters:
        ///   - sha: The commit hash
        ///   - scope: The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.Commit.Ref`
        public func refs(sha: String, scope: InputParams.CommitScope, project: InputParams.Project) async throws -> GLResponse<[GLModel.Commit.Ref]> {
            let options = OutputParamsCollection([
                    OutputParam(key: "id", project),
                    OutputParam(key: "sha", sha),
                    OutputParam(key: "type", scope)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.ref, options: options))
        }
        
        /// Get the discussions of a commit in a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-the-discussions-of-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.Discussion`.
        public func discussions(sha: String,
                                project: InputParams.Project) async throws -> GLResponse<[GLModel.Discussion]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.discussions, options: options))
        }
        
        // MARK: - Commit status
        // https://docs.gitlab.com/ee/api/commits.html#commit-status
        
        /// List the statuses of a commit in a project.
        /// The pagination parameters page and per_page can be used to restrict the list of references.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#list-the-statuses-of-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit SHA
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.Commit.Status`.
        public func statuses(sha: String, project: InputParams.Project,
                             _ callback: ((CommitStatusOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Commit.Status]> {
            let options = CommitStatusOptions(sha: sha, project: project, callback)
            return try await gitlab.execute(.init(endpoint: URLs.statuses, options: options))
        }
        
        /// List merge requests associated with a commit.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#list-merge-requests-associated-with-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit SHA
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: array of `Models.MergeRequest`
        public func mergeRequests(sha: String, project: InputParams.Project) async throws -> GLResponse<[GLModel.MergeRequest]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha", sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.mr, options: options))
        }
        
        /// Get the GPG signature from a commit, if it is signed.
        /// For unsigned commits, it results in a 404 response.
        /// [API Documentation](https://docs.gitlab.com/ee/api/commits.html#get-gpg-signature-of-a-commit).
        ///
        /// - Parameters:
        ///   - sha: The commit hash or name of a repository branch or tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: `Models.Commit.GPGSignature`
        public func gpgSignature(sha: String, project: InputParams.Project) async throws -> GLResponse<GLModel.Commit.GPGSignature> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "sha",  sha)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.gpg, options: options))
        }
    }
    
}
