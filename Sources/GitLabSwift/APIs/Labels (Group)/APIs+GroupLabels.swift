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

// MARK: - GroupLabels + URLs

extension APIs.GroupLabels {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/groups/{id}/labels"
        case get = "/groups/{id}/labels/{label_id}"
        case subscribe = "/groups/{id}/labels/{label_id}/subscribe"
        case unsubscribe = "/groups/{id}/labels/{label_id}/unsubscribe"

        public var value: String { rawValue }
    }
    
}

// MARK: - GroupLabels + APIs

extension APIs {
    
    /// Group labels API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html)
    public class GroupLabels: APIs {
        
        /// Get all labels for a given group.
        /// 
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#list-group-labels)
        ///
        /// - Parameters:
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: list of labels.
        public func list(group: Int,
                         options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Label]> {
            let options = ListOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Get a single label for a given group.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#get-a-single-group-label)
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user.
        ///   - options: configuration callback.
        /// - Returns: label.
        public func get(id: Int,
                        group: Int,
                        options: ((ListOptions) -> Void)? = nil) async throws -> GLResponse<GLModel.Label> {
            let options = ListOptions(options)
            options.customOptions = [
                OutputParam(key: "label_id", id),
                OutputParam(key: "id", group)
            ]
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Create a new group label for a given group.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#create-a-new-group-label)
        ///
        /// - Parameters:
        ///   - name: The name of the label
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - color: The color of the label given in 6-digit hex notation with leading ‘#’ sign.
        ///   - description: The description of the label.
        /// - Returns: label created
        public func create(name: String,
                           group: Int,
                           color: String,
                           description: String? = nil) async throws -> GLResponse<GLModel.Label> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "name", name),
                OutputParam(key: "color", color),
                OutputParam(key: "description", description)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.list, options: options))
        }
        
        /// Updates an existing group label.
        /// At least one parameter is required, to update the group label.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#update-a-group-label)
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - name: The new name of the label
        ///   - color: The color of the label given in 6-digit hex notation with leading ‘#’ sign.
        ///   - description: The description of the label.
        /// - Returns: updated label
        public func update(id: Int,
                           group: Int,
                           name: String? = nil,
                           color: String? = nil,
                           description: String? = nil) async throws -> GLResponse<GLModel.Label> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "label_id", id),
                OutputParam(key: "new_name", name),
                OutputParam(key: "color", color),
                OutputParam(key: "description", description)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.list, options: options))
        }
        
        /// Deletes a group label with a given name.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#delete-a-group-label)
        ///
        /// - Parameters:
        ///   - id: The ID or title of a group’s label.
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: no response
        public func delete(id: Int,
                           group: Int) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.list, options: options))
        }
        
        /// Subscribes the authenticated user to a group label to receive notifications.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#subscribe-to-a-group-label)
        ///
        /// - Parameters:
        ///   - id: The ID or URL-encoded path of the group owned by the authenticated user
        ///   - group: The ID or title of a group’s label.
        /// - Returns: label
        public func subscribe(id: Int,
                              group: Int) async throws -> GLResponse<GLModel.Label> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.subscribe, options: options))
        }
        
        /// Unsubscribes the authenticated user from a group label to not receive notifications from it.
        /// If the user is not subscribed to the label, the status code 304 is returned.
        /// 
        /// [API Documentation](https://docs.gitlab.com/ee/api/group_labels.html#unsubscribe-from-a-group-label)
        ///
        /// - Parameters:
        ///   - id: he ID or title of a group’s label.
        ///   - group: The ID or URL-encoded path of the group owned by the authenticated user
        /// - Returns: label
        public func unsubscribe(id: Int,
                                group: Int) async throws -> GLResponse<GLModel.Label> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", group),
                OutputParam(key: "label_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.unsubscribe, options: options))
        }
    }
    
}
