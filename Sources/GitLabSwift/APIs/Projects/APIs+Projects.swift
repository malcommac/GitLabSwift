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
    
    /// Interact with projects using the REST API.
    /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html)
    ///
    /// A project in GitLab can be `private`, `internal`, or `public`.
    /// The visibility level is determined by the visibility field in the project.
    ///
    /// Values for the project visibility level are:
    ///  - `private`: project access must be granted explicitly to each user.
    ///  - `internal`: the project can be cloned by any signed-in user except external users.
    ///  - `public`: the project can be accessed without any authentication.
    ///
    public class Projects: APIService {
        
        /// Return all visible projects across GitLab for the authenticated user.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-all-projects).
        ///
        /// - Returns: list of projects.
        public func list(_ callback: ((APIOptions.SearchProjects) -> Void)? = nil) async throws -> GitLabResponse<[Model.Project]> {
            try await gitlab.execute(.init(endpoint: Endpoints.Projects.all,
                                           options: APIOptions.SearchProjects(callback)))
        }
        
        /// Return the list of projects eventually owned by the user.
        /// If not specified, all visible projects across GitLab for the authenticated user.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-user-projects).
        ///
        /// - Parameters:
        ///   - userID: user identifier.
        ///   - callback: options configuration.
        /// - Returns: list of projects.
        public func usersProjects(_ userID: Int, _ callback: ((APIOptions.SearchUserProjects) -> Void)? = nil) async throws -> GitLabResponse<[Model.Project]> {
            let options = APIOptions.SearchUserProjects(userID: userID, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.user_projects, options: options))
        }
        
        /// Get a list of visible projects starred by the given user.
        /// When accessed without authentication, only public projects are returned.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-projects-starred-by-a-user).
        ///
        /// - Parameter userID: user identifier.
        /// - Returns: list of projects
        public func userStarred(_ userID: Int) async throws -> GitLabResponse<[Model.Project]> {
            let options = APIOptionsCollection([
                APIOption(key: "user_id", userID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.starred_projects, options: options))
        }
        
        /// Get a specific project.
        /// This endpoint can be accessed without authentication if the project is publicly accessible.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#get-single-project).
        ///
        /// - Parameters:
        ///   - projectID: The ID or URL-encoded path of the project.
        ///   - callback: options configuration.
        /// - Returns: found project, if any.
        public func get(_ projectID: DataTypes.ProjectID, _ callback: ((APIOptions.SearchSingleProject) -> Void)? = nil) async throws -> GitLabResponse<Model.Project> {
            let options = APIOptions.SearchSingleProject(projectID: projectID, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.detail, options: options))
        }
        
        /// Get the users list of a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#get-project-users).
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - callback: configuration callback.
        /// - Returns: `[Models.User]`
        public func usersList(project: DataTypes.ProjectID, _ callback: ((APIOptions.ProjectUsersOptions) -> Void)? = nil) async throws -> GitLabResponse<[Model.User]> {
            let options = APIOptions.ProjectUsersOptions(projectID: project, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.users, options: options))
        }
        
        /// Get a list of ancestor groups for this project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-a-projects-groups).
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - callback: configuration callback.
        /// - Returns: array of `Models.Group`
        public func groupsOfProject(_ project: DataTypes.ProjectID, _ callback: ((APIOptions.ProjectGroups) -> Void)? = nil) async throws -> GitLabResponse<[Model.Group]> {
            let options = APIOptions.ProjectGroups(projectID: project, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.groups, options: options))
        }
        
        /*
         public func create(name: String? = nil, path: String? = nil, _  callback: ((APIOptions.ProjectGroups) -> Void)? = nil) async throws -> GitLabResponse<Models.Project> {
            
        }
         
         public func edit(name: String? = nil, path: String? = nil, _  callback: ((APIOptions.ProjectGroups) -> Void)? = nil) async throws -> GitLabResponse<Models.Project> {
             
         }
         
         public func createForUser(name: String? = nil, path: String? = nil, _  callback: ((APIOptions.ProjectGroups) -> Void)? = nil) async throws -> GitLabResponse<Models.Project> {
             
         }
         */
        
        /// Forks a project into the user namespace of the authenticated user or the one provided.
        ///
        /// The forking operation for a project is asynchronous and is completed in a background job.
        /// The request returns immediately. To determine whether the fork of the project has completed,
        /// query the import_status for the new project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#fork-project)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - callback: configuration callback.
        /// - Returns: generic response
        public func fork(project: DataTypes.ProjectID, _ callback: ((APIOptions.ProjectFork) -> Void)? = nil) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptions.ProjectFork(projectID: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.fork, options: options))
        }
        
        /// List the projects accessible to the calling user that have an established,
        /// forked relationship with the specified project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-forks-of-a-project)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - callback: configuration callback.
        /// - Returns: `Models.Project`
        public func forks(ofProject project: DataTypes.ProjectID, _ callback: ((APIOptions.ProjectForkSearch) -> Void)? = nil) async throws -> GitLabResponse<[Model.Project]> {
            let options = APIOptions.ProjectForkSearch(projectID: project, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.fork, options: options))
        }
        
        /// Stars a given project.
        /// Returns status code 304 if the project is already starred.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#star-a-project).
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: `Models.Project`
        public func star(project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Project> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.star, options: options))
        }
        
        /// Unstars a given project. Returns status code 304 if the project is not starred.
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: `Models.Project`
        public func unstar(project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Project> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.unstar, options: options))
        }
        
        /// List the users who starred the specified project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-starrers-of-a-project)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - search: Search for specific users.
        public func starrers(project: DataTypes.ProjectID, search: String? = nil)
        async throws -> GitLabResponse<[Model.User]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.starrers, options: options))
        }
        
        /// Get languages used in a project with percentage value.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#languages).
        ///
        /// - Parameter id: The ID or URL-encoded path of the project.
        /// - Returns: a dictionary with languages and their percentage
        public func languages(id: DataTypes.ProjectID) async throws ->  GitLabResponse<[String: Double]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Projects.languages, options: options))
        }
        
        /// Archives the project if the user is either an administrator or the owner of this project.
        /// This action is idempotent, thus archiving an already archived project does not change the project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#archive-a-project)
        ///
        /// - Parameter id: The ID or URL-encoded path of the project.
        /// - Returns: archived project
        public func archive(id: DataTypes.ProjectID) async throws ->  GitLabResponse<Model.Project> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.archive, options: options))
        }
        
        /// Unarchives the project if the user is either an administrator or the owner of this project.
        /// This action is idempotent, thus unarchiving a non-archived project doesn’t change the project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#unarchive-a-project).
        ///
        /// - Parameter id: The ID or URL-encoded path of the project.
        /// - Returns: unarchived project.
        public func unarchive(id: DataTypes.ProjectID) async throws ->  GitLabResponse<Model.Project> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.unarchive, options: options))
        }
        
        /// Deletes a project including all associated resources (including issues and merge requests).
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#delete-project).
        ///
        /// - Parameter id: The ID or URL-encoded path of the project.
        /// - Returns: generic response..
        public func delete(id: DataTypes.ProjectID) async throws ->  GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Projects.detail, options: options))
        }
        
        /// Restores project marked for deletion.
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#restore-project-marked-for-deletion)
        ///
        /// - Parameter id: The ID or URL-encoded path of the project.
        /// - Returns: generic response
        public func restore(id: DataTypes.ProjectID) async throws ->  GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Projects.detail, options: options))
        }
        
        /// Uploads a file to the specified project to be used in an issue or merge request description, or a comment.
        ///
        /// - Parameters:
        ///   - id: The ID or URL-encoded path of the project.
        ///   - filePath: The file to be uploaded.
        /// - Returns: uploaded file info.
        public func uploadFile(id: DataTypes.ProjectID, filePath: String) async throws ->  GitLabResponse<Model.UploadedFile> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id),
                APIOption(key: "file", location: .fileInForm, filePath)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Projects.upload, options: options))
        }
    }
    
}
