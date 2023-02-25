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
    
    /// Tags API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/tags.html#get-x509-signature-of-a-tag
    public class Tags: APIService {
        
        /// Get a list of repository tags from a project, sorted by update date and time in descending order.
        /// This endpoint can be accessed without authentication if the repository is publicly accessible.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html#list-project-repository-tags)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - order: Return tags ordered by value.
        ///   - sort: Return tags sorted by value.
        ///   - search: Return list of tags matching the search criteria.
        /// - Returns: tags
        public func list(project: DataTypes.ProjectID,
                         order: DataTypes.TagsOrder? = nil,
                         sort: DataTypes.Sort? = nil,
                         search: DataTypes.Search? = nil) async throws -> GitLabResponse<[Model.Tag]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "order_by", order),
                APIOption(key: "sort", sort),
                APIOption(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Tags.list, options: options))
        }
        
        /// Get a specific repository tag determined by its name.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html#get-a-single-repository-tag)
        ///
        /// - Parameters:
        ///   - name: The name of the tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: found tag
        public func get(name: String,
                        project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Tag> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "tag_name", name)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Tags.get, options: options))
        }
        
        /// Creates a new tag in the repository that points to the supplied ref.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html#create-a-new-tag)
        ///
        /// - Parameters:
        ///   - name: The name of a tag
        ///   - ref: Create tag using commit SHA, another tag name, or branch name
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - message: Creates annotated tag
        /// - Returns: new tag
        public func create(name: String,
                           ref: String,
                           project: DataTypes.ProjectID,
                           message: String? = nil) async throws -> GitLabResponse<Model.Tag> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "tag_name", name),
                APIOption(key: "ref", ref),
                APIOption(key: "message", message)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Tags.list, options: options))
        }
        
        /// Deletes a tag of a repository with given name.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html#delete-a-tag)
        ///
        /// - Parameters:
        ///   - name: The name of a tag
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: no response
        public func delete(name: String,
                           project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "tag_name", name)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Tags.get, options: options))
        }

    }
}
