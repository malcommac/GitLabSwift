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

// MARK: - Tags + URLs

extension APIs.Tags {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/projects/{id}/repository/tags"
        case get = "/projects/{id}/repository/tags/{tag_name}"
        
        public var value: String { rawValue }
    }
}

// MARK: Tags + APIs

extension APIs {
    
    /// Tags API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/tags.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/tags.html#get-x509-signature-of-a-tag
    public class Tags: APIs {
        
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
        public func list(project: InputParams.Project,
                         order: InputParams.TagsOrder? = nil,
                         sort: InputParams.Sort? = nil,
                         search: InputParams.Search? = nil) async throws -> GLResponse<[GLModel.Tag]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "order_by", order),
                OutputParam(key: "sort", sort),
                OutputParam(key: "search", search)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
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
                        project: InputParams.Project) async throws -> GLResponse<GLModel.Tag> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "tag_name", name)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
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
                           project: InputParams.Project,
                           message: String? = nil) async throws -> GLResponse<GLModel.Tag> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "tag_name", name),
                OutputParam(key: "ref", ref),
                OutputParam(key: "message", message)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.list, options: options))
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
                           project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "tag_name", name)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.get, options: options))
        }

    }
}
