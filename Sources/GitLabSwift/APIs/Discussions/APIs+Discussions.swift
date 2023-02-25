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

// MARK: - Discussions + URLs

extension APIs {
    
    fileprivate enum URLs: String, GLEndpoint {
        case discussions = "/projects/{id}/issues/{issue_iid}/discussions"
        case detail = "/projects/{id}/issues/{issue_iid}/discussions/{discussion_id}"
        case notes = "/projects/{id}/issues/{issue_iid}/discussions/{discussion_id}/notes"
        case snippet = "/projects/{id}/snippets/{snippet_id}/discussions"
        case snippet_discussion = "/projects/{id}/snippets/{snippet_id}/discussions/{discussion_id}"
        case merge_requests = "/projects/{id}/merge_requests/{merge_request_iid}/discussions"
        case merge_request = "/projects/{id}/merge_requests/{merge_request_iid}/discussions/{discussion_id}"

        public var value: String { rawValue }
    }
    
}

// MARK: - Discussions + APIs

extension APIs {
    
    /// Discussions APIs.
    ///
    /// Discussions are a set of related notes on:
    /// - Snippets
    /// - Issues
    /// - Epics
    /// - Merge requests
    /// - Commits
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/discussions.html#list-group-epic-discussion-items
    /// - https://docs.gitlab.com/ee/api/discussions.html#get-single-epic-discussion-item
    /// - https://docs.gitlab.com/ee/api/discussions.html#create-new-epic-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-epic-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#modify-existing-epic-thread-note
    /// - https://docs.gitlab.com/ee/api/discussions.html#delete-an-epic-thread-note
    /// - https://docs.gitlab.com/ee/api/discussions.html#create-new-merge-request-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#resolve-a-merge-request-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-merge-request-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#modify-an-existing-merge-request-thread-note
    /// - https://docs.gitlab.com/ee/api/discussions.html#delete-a-merge-request-thread-note
    /// - https://docs.gitlab.com/ee/api/discussions.html#list-project-commit-discussion-items
    /// - https://docs.gitlab.com/ee/api/discussions.html#get-single-commit-discussion-item
    /// - https://docs.gitlab.com/ee/api/discussions.html#create-new-commit-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-commit-thread
    /// - https://docs.gitlab.com/ee/api/discussions.html#modify-an-existing-commit-thread-note
    /// - https://docs.gitlab.com/ee/api/discussions.html#delete-a-commit-thread-note
    public class Discussions: APIs {
        
        // MARK: - Issues
        // https://docs.gitlab.com/ee/api/discussions.html#issues
        
        /// Gets a list of all discussion items for a single issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-issue-discussion-items)
        ///
        /// - Parameters:
        ///   - issue: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: array of `Models.Discussion`.
        public func list(issue: Int,
                         project: InputParams.Project) async throws -> GLResponse<[GLModel.Discussion]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.discussions, options: options))
        }
        
        /// Returns a single discussion item for a specific project issue-
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#get-single-issue-discussion-item)
        ///
        /// - Parameters:
        ///   - discussion: The ID of a discussion item.
        ///   - issue: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: a single discussion.
        public func get(discussion: String,
                        issue: Int,
                        project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "discussion_id", discussion)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.detail, options: options))
        }
        
        /// Creates a new thread to a single project issue.
        /// This is similar to creating a note but other comments (replies) can be added to it later.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#create-new-issue-thread)
        ///
        /// - Parameters:
        ///   - issueID: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        ///   - body: The content of the thread.
        ///   - createdAt: Creation date of the thread, uses current if not set.
        /// - Returns: the discussion created.
        public func create(issue: Int,
                           body: String,
                           createdAt: Date? = nil,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "body", body),
                OutputParam(key: "created_at", createdAt)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.detail, options: options))
        }
        
        /// Adds a new note to the thread.
        /// NOTE: This can also create a thread from a single comment.
        /// WARNING: Notes can be added to other items than comments, such as system notes, making them threads.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-issue-thread)
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply.
        ///   - createdAt: Creation date of the thread, uses current if not set.
        ///   - note: The ID of a thread note.
        ///   - discussion: The ID of a thread.
        ///   - issue: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: discussion created.
        public func addNote(body: String,
                            createdAt: Date? = nil,
                            note: Int,
                            discussion: Int,
                            issue: Int,
                            project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "discussion_id", discussion),
                OutputParam(key: "note_id", note),
                OutputParam(key: "body", body),
                OutputParam(key: "created_at", createdAt)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.notes, options: options))
        }
        
        /// Modify existing issue thread note.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#modify-existing-issue-thread-note)
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply.
        ///   - note: The ID of a thread note.
        ///   - discussion: The ID of a thread.
        ///   - issue: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: modified discussion.
        public func modifyNote(body: String,
                               note: Int,
                               discussion: Int,
                               issue: Int,
                               project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "discussion_id", discussion),
                OutputParam(key: "note_id", note),
                OutputParam(key: "body", body)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.notes, options: options))
        }
        
        /// Deletes an existing thread note of an issue.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#delete-an-issue-thread-note)
        ///
        /// - Parameters:
        ///   - note: The ID of a discussion note.
        ///   - discussion: The ID of a discussion.
        ///   - issue: The IID of an issue.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: generic response.
        public func deleteNote(note: Int,
                               discussion: Int,
                               issue: Int,
                               project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "issue_iid", issue),
                OutputParam(key: "discussion_id", discussion),
                OutputParam(key: "note_id", note)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.notes, options: options))
        }
        
        // MARK: - Snippets
        // https://docs.gitlab.com/ee/api/discussions.html#snippets
        
        /// Gets a list of all discussion items for a single snippet.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-snippet-discussion-items)
        ///
        /// - Parameters:
        ///   - snippet: The ID of an snippet.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: discussions
        public func list(snippet: Int,
                         project: InputParams.Project) async throws -> GLResponse<[GLModel.Discussion]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.snippet, options: options))
        }
        
        /// Returns a single discussion item for a specific project snippet.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#get-single-snippet-discussion-item)
        ///
        /// - Parameters:
        ///   - snippet: The ID of an snippet.
        ///   - discussion: The ID of a discussion item.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: discussion
        public func get(snippet: Int,
                        discussion: Int,
                        project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet),
                OutputParam(key: "discussion_id", discussion)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.snippet_discussion, options: options))
        }
        
        /// Creates a new thread to a single project snippet.
        /// This is similar to creating a note but other comments (replies) can be added to it later.
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#create-new-snippet-thread)
        ///
        /// - Parameters:
        ///   - body: The content of a discussion.
        ///   - date: creation date, if `nil` current date is used.
        ///   - snippet: The ID of an snippet.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: discussion.
        public func createSnippet(body: String,
                                  date: Date? = nil,
                                  snippet: Int,
                                  project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet),
                OutputParam(key: "created_at", date),
                OutputParam(key: "body", body)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.snippet, options: options))
        }
        
        /// Add note to existing snippet thread.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#add-note-to-existing-snippet-thread)
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply.
        ///   - date: creation date, if `nil` current date is used.
        ///   - discussion: The ID of a thread.
        ///   - snippet: The ID of an snippet.
        ///   - project: The ID or URL-encoded path of the project
        /// - Returns: discussion
        public func addNote(body: String,
                            date: Date? = nil,
                            snippet: InputParams.DiscussionSnippet,
                            project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet.snippet_id),
                OutputParam(key: "discussion_id", snippet.discussion_id),
                OutputParam(key: "note_id", snippet.note_id),
                OutputParam(key: "created_at", date),
                OutputParam(key: "body", body)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.snippet, options: options))
        }
        
        /// Modify existing snippet thread note.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#modify-existing-snippet-thread-note)
        ///
        /// - Parameters:
        ///   - body: The content of the note/reply.
        ///   - snippet: Snippet to modify.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: modified snippet.
        public func modifySnippet(body: String,
                                  snippet: InputParams.DiscussionSnippet,
                                  project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet.snippet_id),
                OutputParam(key: "discussion_id", snippet.discussion_id),
                OutputParam(key: "note_id", snippet.note_id),
                OutputParam(key: "body", body)
            ])
            return try await gitlab.execute(.init(.put, endpoint: URLs.snippet, options: options))
        }
        
        /// Deletes an existing thread note of a snippet.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#delete-a-snippet-thread-note)
        ///
        /// - Parameters:
        ///   - snippet: snippet to delete.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: generic response.
        public func deleteSnippet(_ snippet: InputParams.DiscussionSnippet,
                                  project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "snippet_id", snippet.snippet_id),
                OutputParam(key: "discussion_id", snippet.discussion_id),
                OutputParam(key: "note_id", snippet.note_id),
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.snippet, options: options))
        }
        
        // MARK: - Epics
        // TODO: To Be Implemented (https://docs.gitlab.com/ee/api/discussions.html#epics).
        
        // MARK: - Merge Requests
        // https://docs.gitlab.com/ee/api/discussions.html#merge-requests
        
        /// Gets a list of all discussion items for a single merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#list-project-merge-request-discussion-items)
        ///
        /// - Parameters:
        ///   - mergeRequest: The IID of a merge request
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: all discussion items for a single merge request.
        public func list(mergeRequest: Int,
                         project: InputParams.Project) async throws -> GLResponse<[GLModel.Discussion]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.merge_requests, options: options))
        }
        
        /// Returns a single discussion item for a specific project merge request.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/discussions.html#get-single-merge-request-discussion-item)
        ///
        /// - Parameters:
        ///   - mergeRequest: The IID of a merge request.
        ///   - discussionID: The ID of a discussion item.
        ///   - project: The ID or URL-encoded path of the project.
        /// - Returns: single discussion item for a specific project merge request.
        public func get(mergeRequest: Int,
                        discussion: Int,
                        project: InputParams.Project) async throws -> GLResponse<GLModel.Discussion> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "merge_request_iid", mergeRequest),
                OutputParam(key: "discussion_id", discussion)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.merge_request, options: options))
        }
        
        // MARK: - Commits
        // https://docs.gitlab.com/ee/api/discussions.html#commits
        
    }
    
}
