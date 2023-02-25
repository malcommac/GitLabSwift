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

extension APIs.IssuesStatistics {
    
    public class SearchOptions: OutputParamsCollection {
        
        // Comma-separated list of label names, issues must have all labels to be returned.
        @OutputParam(key: "labels")
        public var labels: InputParams.LabelsSearch?
        
        /// The milestone title.
        /// `None` lists all issues with no milestone.
        /// `Any` lists all issues that have an assigned milestone.
        @OutputParam(key: "milestone")
        public var milestone: InputParams.MilestoneIDSearch?
        
        /// Return issues for the given scope.
        @OutputParam(key: "scope")
        public var scope: InputParams.IssuesScope?
        
        /// Return issues created by the given user id.
        /// Mutually exclusive with `author_username`.
        /// Combine with `scope=all` or `scope=assigned_to_me`.
        @OutputParam(key: "author_id")
        public var authorId: Int?
        
        /// Return issues created by the given username.
        /// Similar to `author_id` and mutually exclusive with `author_id`.
        @OutputParam(key: "author_username")
        public var authorUsername: String?
        
        /// Return issues assigned to the given user.
        @OutputParam(key: "assignee_id")
        public var assigneeId: InputParams.IdSearch?
        
        /// Return issues assigned to the given username.
        /// Similar to `assignee_id` and mutually exclusive with `assignee_id`.
        @OutputParam(key: "assignee_username")
        public var assigneeUsername: String?
        
        /// Return issues associated with the given epic ID.
        /// `None` returns issues that are not associated with an epic.
        /// `Any` returns issues that are associated with an epic.
        @OutputParam(key: "epic_id")
        public var epicId: InputParams.IdSearch?
        
        /// Return issues reacted by the authenticated user by a given emoji.
        /// `None` returns issues not given a reaction.
        /// `Any` returns issues given at least one reaction.
        @OutputParam(key: "my_reaction_emoji")
        public var myReactionEmoji: InputParams.EmojiSearch?
        
        /// Return only the issues having the given iid.
        @OutputParam(key: "iids")
        public var iids: [Int]?
        
        /// Search issues against their `title` and `description`.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Modify the scope of the search attribute. `title`, `description` or both.
        @OutputParam(key: "in")
        public var `in`: InputParams.SearchInScope?
        
        /// Return issues created on or after the given time.
        @OutputParam(key: "created_after")
        public var createdAfter: Date?
        
        /// Return issues created on or before the given time.
        @OutputParam(key: "created_before")
        public var createdBefore: Date?
        
        /// Return issues updated on or after the given time.
        @OutputParam(key: "updated_after")
        public var updatedAfter: Date?
        
        /// Return issues updated on or before the given time
        @OutputParam(key: "updated_before")
        public var updatedBefore: Date?
        
        /// Filter confidential or public issues.
        @OutputParam(key: "confidential")
        public var confidential: Bool?
        
        // MARK: - Initialization
        
        public init(_ configure: ((SearchOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
