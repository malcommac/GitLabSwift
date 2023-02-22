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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html).
    public class Discussions: APIService {
        
        // MARK: - Issues
        // https://docs.gitlab.com/ee/api/discussions.html#issues
        
        /// Gets a list of all discussion items for a single issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-issue-discussion-items)
        ///
        /// - Parameters:
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: array of `Models.Discussion`
        public func list(issueID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Discussion]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.discussions, options: options))
        }
        
        /// Returns a single discussion item for a specific project issue
        ///
        /// - Parameters:
        ///   - discussionID: The ID of a discussion item
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: a single discussion.
        public func get(discussionID: String, issueID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID),
                APIOption(key: "discussion_id", discussionID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.detail, options: options))
        }
        
        /// Creates a new thread to a single project issue.
        /// This is similar to creating a note but other comments (replies) can be added to it later.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#create-new-issue-thread)
        ///
        /// - Parameters:
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        ///   - body: The content of the thread
        ///   - createdAt: Creation date of the thread, uses current if not set.
        /// - Returns: the discussion created.
        public func create(issueID: Int, body: String, createdAt: Date? = nil, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID),
                APIOption(key: "body", body),
                APIOption(key: "created_at", createdAt)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Discussions.detail, options: options))
        }
        
        /// Adds a new note to the thread.
        /// NOTE: This can also create a thread from a single comment.
        /// WARNING: Notes can be added to other items than comments, such as system notes, making them threads.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-issue-thread).
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply
        ///   - createdAt: Creation date of the thread, uses current if not set.
        ///   - noteID: The ID of a thread note
        ///   - discussionID: The ID of a thread
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussion created.
        public func create(noteWithBody body: String, createdAt: Date? = nil, noteID: Int, discussionID: Int, issueID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID),
                APIOption(key: "discussion_id", discussionID),
                APIOption(key: "note_id", noteID),
                APIOption(key: "body", body),
                APIOption(key: "created_at", createdAt)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Discussions.notes, options: options))
        }
        
        /// Modify existing thread note of an issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#modify-existing-issue-thread-note).
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply
        ///   - noteID: The ID of a thread note
        ///   - discussionID: The ID of a thread
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: modified discussion.
        public func edit(noteWithBody body: String, noteID: Int, discussionID: Int, issueID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID),
                APIOption(key: "discussion_id", discussionID),
                APIOption(key: "note_id", noteID),
                APIOption(key: "body", body),
            ])
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.Discussions.notes, options: options))
        }
        
        /// Deletes an existing thread note of an issue.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#delete-an-issue-thread-note).
        ///
        /// - Parameters:
        ///   - noteID: The ID of a discussion note
        ///   - discussionID: The ID of a discussion
        ///   - issueID: The IID of an issue
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: generic response
        public func deleteNote(noteID: Int, discussionID: Int, issueID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "issue_iid", issueID),
                APIOption(key: "discussion_id", discussionID),
                APIOption(key: "note_id", noteID)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Discussions.notes, options: options))
        }
        
        // MARK: - Snippets
        // https://docs.gitlab.com/ee/api/discussions.html#snippets
        
        /// Gets a list of all discussion items for a single snippet.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-snippet-discussion-items).
        ///
        /// - Parameters:
        ///   - snippetID: The ID of an snippet
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussions
        public func list(snippetID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Discussion]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippetID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.snippet, options: options))
        }
        
        /// Returns a single discussion item for a specific project snippet
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#get-single-snippet-discussion-item)
        ///
        /// - Parameters:
        ///   - snippetID: The ID of an snippet
        ///   - discussionID: The ID of a discussion item
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussion
        public func get(_ snippetID: Int, discussionID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippetID),
                APIOption(key: "discussion_id", discussionID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.snippetDiscussion, options: options))
        }
        
        /// Creates a new thread to a single project snippet.
        /// This is similar to creating a note but other comments (replies) can be added to it later.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#create-new-snippet-thread)
        ///
        /// - Parameters:
        ///   - body: The content of a discussion.
        ///   - date: creation date, if `nil` current date is used.
        ///   - snippetID: The ID of an snippet
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussion.
        public func createSnippetThread(body: String, date: Date? = nil, snippetID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippetID),
                APIOption(key: "created_at", date),
                APIOption(key: "body", body)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Discussions.snippet, options: options))
        }
        
        /// Add note to existing snippet thread.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-snippet-thread).
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply
        ///   - date: creation date, if `nil` current date is used.
        ///   - discussionID: The ID of a thread
        ///   - snippetID: The ID of an snippet.
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussion
        public func addNote(body: String, date: Date? = nil, snippet: DataTypes.DiscussionSnippet, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippet.snippet_id),
                APIOption(key: "discussion_id", snippet.discussion_id),
                APIOption(key: "note_id", snippet.note_id),
                APIOption(key: "created_at", date),
                APIOption(key: "body", body)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Discussions.snippet, options: options))
        }
        
        /// Modify existing snippet thread note.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#modify-existing-snippet-thread-note).
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply
        ///   - snippet: Snippet to modify.
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: modified snippet.
        public func modifySnippet(body: String, snippet: DataTypes.DiscussionSnippet, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippet.snippet_id),
                APIOption(key: "discussion_id", snippet.discussion_id),
                APIOption(key: "note_id", snippet.note_id),
                APIOption(key: "body", body)
            ])
            return try await gitlab.execute(.init(.put, endpoint: Endpoints.Discussions.snippet, options: options))
        }
        
        /// Deletes an existing thread note of a snippet.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#delete-a-snippet-thread-note).
        ///
        /// - Parameters:
        ///   - snippet: snippet to delete.
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: generic response.
        public func deleteSnippet(_ snippet: DataTypes.DiscussionSnippet, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "snippet_id", snippet.snippet_id),
                APIOption(key: "discussion_id", snippet.discussion_id),
                APIOption(key: "note_id", snippet.note_id),
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Discussions.snippet, options: options))
        }
        
        // MARK: - Epics
        // TODO: To Be Implemented (https://docs.gitlab.com/ee/api/discussions.html#epics).
        
        // MARK: - Merge Requests
        // https://docs.gitlab.com/ee/api/discussions.html#merge-requests
        
        /// Gets a list of all discussion items for a single merge request.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-merge-request-discussion-items).
        ///
        /// - Parameters:
        ///   - mergeRequest: The IID of a merge request
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: all discussion items for a single merge request.
        public func list(mergeRequest: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Discussion]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.mergeRequests, options: options))
        }
        
        /// Returns a single discussion item for a specific project merge request
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#get-single-merge-request-discussion-item).
        ///
        /// - Parameters:
        ///   - mergeRequest: The IID of a merge request
        ///   - discussionID: The ID of a discussion item
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: single discussion item for a specific project merge request.
        public func get(mergeRequest: Int, discussionID: Int, project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Discussion> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "merge_request_iid", mergeRequest),
                APIOption(key: "discussion_id", discussionID)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Discussions.mergeRequest, options: options))
        }
        
        
    }
    
}
