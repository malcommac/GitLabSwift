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

// MARK: - Projects + URLs

extension APIService.Projects {
    
    fileprivate enum URLs: String, GLEndpoint {
        case all = "/projects"
        case users = "/projects/{id}/users"
        case groups = "/projects/{id}/groups"
        case detail = "/projects/{id}"
        case starred_projects = "/users/{user_id}/starred_projects"
        case user_projects = "/users/{user_id}/projects"
        case fork = "/projects/{id}/fork"
        case star = "/projects/{id}/star"
        case unstar = "/projects/{id}/unstar"
        case languages = "/projects/{id}/languages"
        case starrers = "/projects/{id}/starrers"
        case archive = "/projects/{id}/archive"
        case unarchive = "/projects/{id}/unarchive"
        case upload = "/projects/{id}/uploads"

        public var value: String { rawValue }
    }
    
}

// MARK: - Projects + APIs

extension APIService {
    
    /// Interact with projects using the REST API.
    /// 
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
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/projects.html#list-a-projects-shareable-groups
    /// - https://docs.gitlab.com/ee/api/projects.html#create-project
    /// - https://docs.gitlab.com/ee/api/projects.html#create-project-for-user
    /// - https://docs.gitlab.com/ee/api/projects.html#edit-project
    /// - https://docs.gitlab.com/ee/api/projects.html#upload-a-file
    /// - https://docs.gitlab.com/ee/api/projects.html#upload-a-project-avatar
    /// - https://docs.gitlab.com/ee/api/projects.html#remove-a-project-avatar
    /// - https://docs.gitlab.com/ee/api/projects.html#share-project-with-group
    /// - https://docs.gitlab.com/ee/api/projects.html#delete-a-shared-project-link-within-a-group
    /// - https://docs.gitlab.com/ee/api/projects.html#import-project-members
    /// - https://docs.gitlab.com/ee/api/projects.html#list-project-hooks
    /// - https://docs.gitlab.com/ee/api/projects.html#get-project-hook
    /// - https://docs.gitlab.com/ee/api/projects.html#edit-project-hook
    /// - https://docs.gitlab.com/ee/api/projects.html#delete-project-hook
    /// - https://docs.gitlab.com/ee/api/projects.html#create-a-forked-fromto-relation-between-existing-projects
    /// - https://docs.gitlab.com/ee/api/projects.html#delete-an-existing-forked-from-relationship
    /// - https://docs.gitlab.com/ee/api/projects.html#search-for-projects-by-name
    /// - https://docs.gitlab.com/ee/api/projects.html#start-the-housekeeping-task-for-a-project
    /// - https://docs.gitlab.com/ee/api/projects.html#get-project-push-rules
    /// - https://docs.gitlab.com/ee/api/projects.html#add-project-push-rule
    /// - https://docs.gitlab.com/ee/api/projects.html#edit-project-push-rule
    /// - https://docs.gitlab.com/ee/api/projects.html#delete-project-push-rule
    /// - https://docs.gitlab.com/ee/api/projects.html#get-groups-to-which-a-user-can-transfer-a-project
    /// - https://docs.gitlab.com/ee/api/projects.html#transfer-a-project-to-a-new-namespace
    /// - https://docs.gitlab.com/ee/api/projects.html#get-a-projects-pull-mirror-details
    /// - https://docs.gitlab.com/ee/api/projects.html#configure-pull-mirroring-for-a-project
    /// - https://docs.gitlab.com/ee/api/projects.html#download-snapshot-of-a-git-repository
    /// - https://docs.gitlab.com/ee/api/projects.html#get-the-path-to-repository-storage
    public class Projects: APIService {
        
        /// Return all visible projects across GitLab for the authenticated user.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-all-projects)
        ///
        /// - Parameter options: search configuration callback.
        /// - Returns: list of projects.
        public func list(options: ((SearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Project]> {
            let options = SearchOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.all, options: options))
        }
        
        /// Return the list of projects eventually owned by the user.
        /// If not specified, all visible projects across GitLab for the authenticated user.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-user-projects)
        ///
        /// - Parameters:
        ///   - userID: user identifier.
        ///   - callback: options configuration.
        /// - Returns: list of projects.
        public func listUsersProjects(_ user: Int,
                                  _ callback: ((UserProjectsOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Project]> {
            let options = UserProjectsOptions(user: user, callback)
            return try await gitlab.execute(.init(endpoint: URLs.user_projects, options: options))
        }
        
        /// Get a list of visible projects starred by the given user.
        /// When accessed without authentication, only public projects are returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-projects-starred-by-a-user)
        ///
        /// - Parameter user: user identifier.
        /// - Returns: list of projects.
        public func listUserStarredProjects(_ user: Int) async throws -> GLResponse<[GLModel.Project]> {
            let options = OutputParamsCollection([
                OutputParam(key: "user_id", user)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.starred_projects, options: options))
        }
        
        /// Get a specific project.
        /// This endpoint can be accessed without authentication if the project is publicly accessible.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#get-single-project)
        ///
        /// - Parameters:
        ///   - projectID: The ID or URL-encoded path of the project.
        ///   - options: options configuration.
        /// - Returns: found project, if any.
        public func get(project: InputParams.Project,
                        options: ((SearchProjectOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.Project> {
            let options = SearchProjectOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.detail, options: options))
        }
        
        /// Get the users list of a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#get-project-users)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - callback: configuration callback.
        /// - Returns: `[Models.User]`
        public func usersList(project: InputParams.Project,
                              options: ((ProjectUsersOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.User]> {
            let options = ProjectUsersOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.users, options: options))
        }
        
        /// Get a list of ancestor groups for this project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-a-projects-groups)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - options: configuration callback.
        /// - Returns: array of `Models.Group`
        public func groupsOfProject(_ project: InputParams.Project,
                                    options: ((ProjectGroupsOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Group]> {
            let options = ProjectGroupsOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.groups, options: options))
        }
        
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
        ///   - options: configuration callback.
        /// - Returns: generic response
        public func fork(project: InputParams.Project,
                         options: ((ForkOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.NoResponse> {
            let options = ForkOptions(project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.fork, options: options))
        }
        
        /// List the projects accessible to the calling user that have an established,
        /// forked relationship with the specified project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-forks-of-a-project)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - options: configuration callback.
        /// - Returns: `Models.Project`
        public func forksOfProject(_ project: InputParams.Project,
                                   options: ((ForksSearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Project]> {
            let options = ForksSearchOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.fork, options: options))
        }
        
        /// Stars a given project.
        /// Returns status code 304 if the project is already starred.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#star-a-project)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: `Models.Project`
        public func star(project: InputParams.Project) async throws -> GLResponse<GLModel.Project> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.star, options: options))
        }
        
        /// Unstars a given project. Returns status code 304 if the project is not starred.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#unstar-a-project)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: `Models.Project`
        public func unstar(project: InputParams.Project) async throws -> GLResponse<GLModel.Project> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.unstar, options: options))
        }
        
        /// List the users who starred the specified project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#list-starrers-of-a-project)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project.
        ///   - search: Search for specific users.
        public func starrersOfProject(_ project: InputParams.Project,
                                      search: String? = nil)
        async throws -> GLResponse<[GLModel.User]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.starrers, options: options))
        }
        
        /// Get languages used in a project with percentage value.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#languages)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: a dictionary with languages and their percentage
        public func languagesOfProject(_ project: InputParams.Project) async throws ->  GLResponse<[String: Double]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.languages, options: options))
        }
        
        /// Archives the project if the user is either an administrator or the owner of this project.
        /// This action is idempotent, thus archiving an already archived project does not change the project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#archive-a-project)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: archived project
        public func archive(project: InputParams.Project) async throws ->  GLResponse<GLModel.Project> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.archive, options: options))
        }
        
        /// Unarchives the project if the user is either an administrator or the owner of this project.
        /// This action is idempotent, thus unarchiving a non-archived project doesn’t change the project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#unarchive-a-project)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: unarchived project.
        public func unarchive(project: InputParams.Project) async throws ->  GLResponse<GLModel.Project> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.unarchive, options: options))
        }
        
        /// Deletes a project including all associated resources (including issues and merge requests).
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#delete-project)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: generic response..
        public func delete(project: InputParams.Project) async throws ->  GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.detail, options: options))
        }
        
        /// Restores project marked for deletion.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/projects.html#restore-project-marked-for-deletion)
        ///
        /// - Parameter project: The ID or URL-encoded path of the project.
        /// - Returns: generic response
        public func restore(project: InputParams.Project) async throws ->  GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.detail, options: options))
        }
        
    }
    
}
