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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html)
    public class RepositoryFiles: APIService {
        
        /// Allows you to receive information about file in repository like name, size, and content. File content is Base64 encoded.
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL encoded full path to new file, such as lib%2Fclass%2Erb.
        ///   - ref: The name of branch, tag or commit.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: file
        func fileInfo(path: String,
                      ref: String,
                      project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.File> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "ref", ref),
                APIOption(key: "file_path", path)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.RepositoryFiles.get, options: options))
        }
        
        /// Allows you to receive blame information. Each blame range contains lines and corresponding commit information.
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-file-blame-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL-encoded full path to new file, such aslib%2Fclass%2Erb.
        ///   - ref: The name of branch, tag or commit.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.

        
        /// Allows you to receive blame information. Each blame range contains lines and corresponding commit information.
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
        func blame(path: String,
                   ref: String,
                   filePath: String,
                   rangeStart: Int,
                   rangeEnd: Int,
                   project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.FileBlame> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "ref", ref),
                APIOption(key: "file_path", filePath),
                APIOption(key: "range[start]", rangeStart),
                APIOption(key: "range[end]", rangeEnd)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.RepositoryFiles.blame, options: options))
        }
        
        /// Get raw file from repository.
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#get-raw-file-from-repository)
        ///
        /// - Parameters:
        ///   - path: URL-encoded full path to new file, such as lib%2Fclass%2Erb.
        ///   - ref: The name of branch, tag or commit. Default is the HEAD of the project.
        ///   - lfs: Determines if the response should be Git LFS file contents, rather than the pointer.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: generic response.
        func file(path: String,
                  ref: String,
                  lfs: Bool? = nil,
                  project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "file_path", path),
                APIOption(key: "ref", ref),
                APIOption(key: "lfs", lfs)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.RepositoryFiles.raw, options: options))
        }
        
        /// Allows you to create a single file.
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#create-new-file-in-repository)
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - callback: configuration callback.
        /// - Returns: generic response
        func createFile(branch: String,
                        commit: String,
                        content: String,
                        filePath: String,
                        project: DataTypes.ProjectID,
                        _ callback: ((APIOptions.CreateFile) -> Void)? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptions.CreateFile(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                callback
            )
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.RepositoryFiles.get, options: options))
        }
        
        /// Allows you to update a single file.
        /// [API Documentation](https://docs.gitlab.com/ee/api/repository_files.html#update-existing-file-in-repository)
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - callback: configuration callback.
        /// - Returns: generic response
        func updateFile(branch: String,
                        commit: String,
                        content: String,
                        filePath: String,
                        project: DataTypes.ProjectID,
                        _ callback: ((APIOptions.CreateFile) -> Void)? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptions.CreateFile(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                callback
            )
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.RepositoryFiles.get, options: options))
        }
        
        /// This allows you to delete a single file.
        ///
        /// - Parameters:
        ///   - branch: Name of the new branch to create. The commit is added to this branch.
        ///   - commit: The commit message.
        ///   - content: The file’s content.
        ///   - filePath: The file’s content.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - callback: configuration callback.
        /// - Returns: generic response
        func deleteFile(branch: String,
                        commit: String,
                        content: String,
                        filePath: String,
                        project: DataTypes.ProjectID,
                        _ callback: ((APIOptions.CreateFile) -> Void)? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptions.CreateFile(
                branch: branch,
                commit: commit,
                content: content,
                filePath: filePath,
                project: project,
                callback
            )
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.RepositoryFiles.get, options: options))
        }
        
    }
    
}
