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

// MARK: - RepositoryFiles + URLs

extension APIService.RepositoryFiles {
    
    fileprivate enum URLs: String, GLEndpoint {
        case get = "/projects/{id}/repository/files/{file_path}"
        case blame = "/projects/{id}/repository/files/{file_path}/blame"
        case raw = "/projects/{id}/repository/files/{file_path}/raw"

        public var value: String { rawValue }
    }

}

// MARK: - RepositoryFiles + APIs

extension APIService {
    
    /// Repository files API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html)
    public class RepositoryFiles: APIService {
        
        /// Allows you to receive information about file in repository like name, size, and content. File content is Base64 encoded.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL encoded full path to new file.
        ///   - ref: The name of branch, tag or commit.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: file
        public func fileInfo(path: String,
                             ref: String,
                             project: InputParams.Project) async throws -> GLResponse<GLModel.File> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "ref", ref),
                OutputParam(key: "file_path", path)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Allows you to receive blame information. Each blame range contains lines and corresponding commit information.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-file-blame-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL-encoded full path to new file, such aslib%2Fclass%2Erb.
        ///   - ref: The name of branch, tag or commit.
        ///   - filePath: URL-encoded full path to new file, such aslib%2Fclass%2Erb.
        ///   - rangeStart: The first line of the range to blame.
        ///   - rangeEnd: The last line of the range to blame.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: file blame
        public func blame(path: String,
                          ref: String,
                          filePath: String,
                          rangeStart: Int,
                          rangeEnd: Int,
                          project: InputParams.Project) async throws -> GLResponse<GLModel.FileBlame> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "ref", ref),
                OutputParam(key: "file_path", filePath),
                OutputParam(key: "range[start]", rangeStart),
                OutputParam(key: "range[end]", rangeEnd)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.blame, options: options))
        }
        
        /// Get raw file from repository.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-raw-file-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL-encoded full path to new file, such as lib%2Fclass%2Erb.
        ///   - ref: The name of branch, tag or commit. Default is the HEAD of the project.
        ///   - lfs: Determines if the response should be Git LFS file contents, rather than the pointer.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response.
        public func file(path: String,
                         ref: String,
                         lfs: Bool? = nil,
                         project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "file_path", path),
                OutputParam(key: "ref", ref),
                OutputParam(key: "lfs", lfs)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.raw, options: options))
        }
        
        /// Allows you to create a single file.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#create-new-file-in-repository)
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: generic response
        public func createFile(branch: String,
                               commit: String,
                               content: String,
                               filePath: String,
                               project: InputParams.Project,
                               options: ((CreateOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.NoResponse> {
            let options = CreateOptions(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                options
            )
            return try await gitlab.execute(.init(.post, endpoint: URLs.get, options: options))
        }
        
        /// Allows you to update a single file.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#update-existing-file-in-repository)
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: generic response
        public func updateFile(branch: String,
                               commit: String,
                               content: String,
                               filePath: String,
                               project: InputParams.Project,
                               options: ((CreateOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.NoResponse> {
            let options = CreateOptions(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                options
            )
            return try await gitlab.execute(.init(.put, endpoint: URLs.get, options: options))
        }
        
        /// This allows you to delete a single file.
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: generic response
        public func deleteFile(branch: String,
                               commit: String,
                               content: String,
                               filePath: String,
                               project: InputParams.Project,
                               options: ((CreateOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.NoResponse> {
            let options = CreateOptions(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                options
            )
            return try await gitlab.execute(.init(.delete, endpoint: URLs.get, options: options))
        }
        
    }
    
}
