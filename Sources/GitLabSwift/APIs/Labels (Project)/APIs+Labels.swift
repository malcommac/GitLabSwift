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

// MARK: - Labels + URLs

extension APIService.Labels {
    
    fileprivate enum URLs: String, GLEndpoint {
        case labels = "/projects/{id}/labels"
        case labels_single = "/projects/{id}/labels/{label_id}"
        case labels_promote = "/projects/{id}/labels/{label_id}/promote"
        case labels_subscribe = "/projects/{id}/labels/{label_id}/subscribe"
        case labels_unsubscribe = "/projects/{id}/labels/{label_id}/unsubscribe"
        
        public var value: String { rawValue }
    }
    
}

// MARK: - Labels + APIs

extension APIService {
    
    /// Labels API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#list-labels)
    public class Labels: APIService {
        
        /// Search for user with passed configuration.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#list-labels)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: Options callback configuration.
        /// - Returns: found labels.
        public func list(project: InputParams.Project,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Label]> {
            let options = ListOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.labels, options: options))
        }
        
        /// Get a single label for a given project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#get-a-single-project-label)
        ///
        /// - Parameters:
        ///   - label: The ID or title of a project’s label.
        ///   - includeAncestor: Include ancestor groups. Defaults to true.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: label info.
        public func get(_ label: Int,
                        includeAncestor: Bool? = nil,
                        project: InputParams.Project) async throws -> GLResponse<[GLModel.Label]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "label_id", label),
                OutputParam(key: "include_ancestor_groups", includeAncestor)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.labels_single, options: options))
        }
        
        /// Creates a new label for the given repository with the given name and color.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#create-a-new-label)
        ///
        /// - Parameters:
        ///   - name: name of the label.
        ///   - color: The color of the label given in 6-digit hex notation with leading ‘#’ sign.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: configuration callback.
        /// - Returns: Created label object.
        public func create(name: String,
                           color: String,
                           project: InputParams.Project,
                           options: @escaping ((CreateOptions) -> Void)) async throws -> GLResponse<GLModel.Label> {
            let options = CreateOptions(name: name, color: color, project: project, options)
            return try await gitlab.execute(.init(.post, endpoint: URLs.labels, options: options))
        }
        
        /// Deletes a label with a given name.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#delete-a-label)
        ///
        /// - Parameters:
        ///   - name: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func delete(_ id: String,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.labels_single, options: options))
        }
        
        
        /// Updates an existing label with new name or new color.
        /// At least one parameter is required, to update the label.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#edit-an-existing-label)
        ///
        /// - Parameters:
        ///   - label: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: configuration callback. At least one parameter is required, to update the label.
        /// - Returns: updated label
        public func edit(_ label: String,
                         project: InputParams.Project,
                         options: @escaping ((EditOptions) -> Void)) async throws -> GLResponse<GLModel.Label> {
            let options = EditOptions(label: label, project: project, options)
            return try await gitlab.execute(.init(.put, endpoint: URLs.labels_single, options: options))
        }
        
        
        /// Promotes a project label to a group label.
        /// The label keeps its ID.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#promote-a-project-label-to-a-group-label)
        ///
        /// - Parameters:
        ///   - label: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        public func promoteToGroup(label: String,
                                   project: InputParams.Project) async throws -> GLResponse<GLModel.Label> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "label_id", label)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.labels_promote, options: options))
        }
        
        
        /// Subscribes the authenticated user to a label to receive notifications.  
        /// If the user is already subscribed to the label, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#subscribe-to-a-label)
        ///
        /// - Parameters:
        ///   - label: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        public func subscribe(label: String,
                              project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "label_id", label)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.labels_subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from a label to not receive notifications from it.
        /// If the user is not subscribed to the label, the status code 304 is returned.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#unsubscribe-from-a-label)
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func unsubscribe(label: String,
                                project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "label_id", label)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.labels_unsubscribe, options: options))
        }
        
    }
    
}
