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
    
    public class Labels: APIService {
        
        /// Search for user with passed configuration.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#list-labels).
        ///
        /// - Parameter configure: configuration callback.
        /// - Returns: found users.
        public func list(project: DataTypes.ProjectID, _ callback: ((APIOptions.ListLabels) -> Void)? = nil) async throws -> GitLabResponse<[Model.Label]> {
            let options = APIOptions.ListLabels(callback)
            options.projectID = project
            return try await gitlab.execute(.init(endpoint: Endpoints.labels, options: options))
        }
        
        /// Get a single label for a given project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#get-a-single-project-label).
        ///
        /// - Parameters:
        ///   - id: The ID or title of a project’s label.
        ///   - includeAncestor: Include ancestor groups. Defaults to true.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: label info.
        public func get(id: Int, includeAncestor: Bool? = nil, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Label]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "label_id", id),
                APIOption(key: "include_ancestor_groups", includeAncestor)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.labels_single, options: options))
        }
        
        /// Creates a new label for the given repository with the given name and color.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#create-a-new-label).
        ///
        /// - Parameters:
        ///   - name: name of the label.
        ///   - color: The color of the label given in 6-digit hex notation with leading ‘#’ sign.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback.
        /// - Returns: Created label object.
        public func create(name: String, color: String, project: DataTypes.ProjectID, _ callback: @escaping ((APIOptions.CreateLabel) -> Void)) async throws -> GitLabResponse<Model.Label> {
            let options = APIOptions.CreateLabel(name: name, color: color, project: project, callback)
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.labels, options: options))
        }
        
        
        /// Deletes a label with a given name.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#delete-a-label).
        ///
        /// - Parameters:
        ///   - name: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func delete(_ id: String, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.labels_single, options: options))
        }
        
        
        /// Updates an existing label with new name or new color.
        /// At least one parameter is required, to update the label.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#edit-an-existing-label).
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback. At least one parameter is required, to update the label.
        /// - Returns: updated label
        public func edit(_ id: String, project: DataTypes.ProjectID, _ callback: @escaping ((APIOptions.EditLabel) -> Void)) async throws -> GitLabResponse<Model.Label> {
            let options = APIOptions.EditLabel(id: id, project: project, callback)
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.labels_single, options: options))
        }
        
        
        /// Promotes a project label to a group label.
        /// The label keeps its ID.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#promote-a-project-label-to-a-group-label).
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        public func promoteToGroup(_ id: String, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Label> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.labels_promote, options: options))
        }
        
        
        /// Subscribes the authenticated user to a label to receive notifications.  
        /// If the user is already subscribed to the label, the status code 304 is returned.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#subscribe-to-a-label).
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        public func subscribe(_ id: String, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.labels_subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from a label to not receive notifications from it.
        /// If the user is not subscribed to the label, the status code 304 is returned.
        /// [API Documentation](https://docs.gitlab.com/ee/api/labels.html#unsubscribe-from-a-label)
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: generic response
        public func unsubscribe(_ id: String, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.labels_unsubscribe, options: options))
        }
        
    }
    
}
