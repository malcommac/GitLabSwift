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

extension APIService.Issues {
    
    public class EditOptions: OutputParamsCollection {
        
        // Comma-separated label names to add to an issue.
        @OutputParam(key: "add_labels")
        public var addLabels: Int?
        
        /// The IDs of the users to assign the issue to.
        @OutputParam(key: "assignee_ids")
        public var assigneeIds: [Int]?
        
        /// Set an issue to be confidential.
        @OutputParam(key: "confidential")
        public var confidential: Bool?
        
        /// The description of an issue. Limited to 1,048,576 characters.
        @OutputParam(key: "description")
        public var description: String?
        
        // Flag indicating if the issue’s discussion is locked.
        // If the discussion is locked only project members can add or edit comments.
        @OutputParam(key: "discussion_locked")
        public var discussionLocked: Bool?
        
        /// The due date.
        @OutputParam(key: "due_date")
        public var dueDate: Date?
        
        /// ID of the epic to add the issue to.
        @OutputParam(key: "epic_id")
        public var epicId: Int?
        
        /// IID of the epic to add the issue to.
        @OutputParam(key: "epic_iid")
        public var epicIid: Int?
        
        /// The project reference.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The internal ID of a project’s issue
        @OutputParam(key: "issue_iid")
        public var issue: Int?
        
        /// The type of issue.
        @OutputParam(key: "issue_type")
        public var issueType: InputParams.IssueType?
        
        /// Comma-separated label names for an issue.
        @OutputParam(key: "labels")
        public var labels: String?
        
        /// The global ID of a milestone to assign issue.
        @OutputParam(key: "milestone_id")
        public var milestoneId: Int?
        
        /// The title of an issue.
        @OutputParam(key: "title")
        public var title: String?
        
        /// When the issue was updated.
        @OutputParam(key: "updated_at")
        public var updatedAt: Date?
        
        /// The weight of the issue.
        @OutputParam(key: "weight")
        public var weight: Int?
        
        // MARK: - Initialization
        
        public init(issue: Int,
                    project: InputParams.ProjectID,
                    _ configure: ((EditOptions) -> Void)?) {
            super.init()
            self.issue = issue
            self.project = project
            configure?(self)
        }
        
    }
    
    public class CreateOptions: OutputParamsCollection {
        
        // The ID of the user to assign the issue to. Only appears on GitLab Free.
        @OutputParam(key: "assignee_id")
        public var assigneeId: Int?
        
        /// The IDs of the users to assign the issue to.
        @OutputParam(key: "assignee_ids")
        public var assigneeIds: [Int]?
        
        /// Set an issue to be confidential.
        @OutputParam(key: "confidential")
        public var confidential: Bool?
        
        /// When the issue was created.
        @OutputParam(key: "created_at")
        public var createdAt: Date?
        
        /// The description of an issue. Limited to 1,048,576 characters.
        @OutputParam(key: "description")
        public var description: String?
        
        /// The ID of a discussion to resolve
        @OutputParam(key: "discussion_to_resolve")
        public var discussionToResolve: String?
        
        /// The due date.
        @OutputParam(key: "due_date")
        public var dueDate: Date?
        
        /// ID of the epic to add the issue to.
        @OutputParam(key: "epic_id")
        public var epicId: Int?
        
        /// IID of the epic to add the issue to.
        @OutputParam(key: "epic_iid")
        public var epicIid: Int?
        
        /// The project reference.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The project reference iid.
        @OutputParam(key: "iid")
        public var projectIid: Int?
        
        /// The type of issue.
        @OutputParam(key: "issue_type")
        public var issueType: InputParams.IssueType?
        
        /// Comma-separated label names for an issue.
        @OutputParam(key: "labels")
        public var labels: String?
        
        /// The IID of a merge request in which to resolve all issues.
        @OutputParam(key: "merge_request_to_resolve_discussions_of")
        public var mrToResolveDiscussionOf: Int?
        
        /// The global ID of a milestone to assign issue.
        @OutputParam(key: "milestone_id")
        public var milestoneId: Int?
        
        /// The title of an issue.
        @OutputParam(key: "title")
        public var title: String?
        
        /// The weight of the issue.
        @OutputParam(key: "weight")
        public var weight: Int?
        
        // MARK: - Initialization
        
        public init(title: String,
                    project: InputParams.ProjectID,
                    _ configure: ((CreateOptions) -> Void)?) {
            super.init()
            self.project = project
            self.title = title
            configure?(self)
        }
    
    }
    
    public class ListProjectOptions: ListOptions {
        
        /// Id of the group.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        // MARK: - Initialization
        
        public init(project: InputParams.ProjectID,
                    _ configure: ((ListProjectOptions) -> Void)?) {
            super.init(nil)
            self.project = project
            configure?(self)
        }
        
    }
    
    public class ListGroupOptions: ListOptions {
        
        /// Id of the group.
        @OutputParam(key: "id")
        public var group: Int?
        
        // MARK: - Initialization
        
        public init(group: Int, _ configure: ((ListGroupOptions) -> Void)?) {
            super.init(nil)
            self.group = group
            configure?(self)
        }
        
    }
        
    public class ListOptions: OutputParamsCollection {
        
        /// Return issues assigned to the given user id.
        /// Mutually exclusive with assignee_username.
        /// None returns unassigned issues. Any returns issues with an assignee.
        @OutputParam(key: "assignee_id")
        public var assigneeID: Int?
        
        /// Return issues assigned to the given username.
        @OutputParam(key: "assignee_username")
        public var assigneeUsernames: [String]?
        
        /// Return issues created by the given user id.
        /// Mutually exclusive with `author_username`.
        /// Combine with `scope=all` or `scope=assigned_to_me`.
        @OutputParam(key: "author_id")
        public var author: Int?
        
        /// Return issues created by the given username.
        /// Similar to `author_id` and mutually exclusive with `author_id`.
        @OutputParam(key: "author_username")
        public var authorUsername: String?
        
        /// Filter confidential or public issues.
        @OutputParam(key: "confidential")
        public var confidential: Bool?
        
        /// Return issues created on or after the given time.
        @OutputParam(key: "created_after")
        public var createdAfter: Date?
        
        /// Return issues created on or before the given time.
        @OutputParam(key: "created_before")
        public var createdBefore: Date?
        
        /// Return issues that have no due date, are overdue,
        /// or whose due date is this week, this month,
        /// or between two weeks ago and next month.
        @OutputParam(key: "due_date")
        public var dueDate: InputParams.DueDate?
        
        /// Return issues associated with the given epic ID.
        @OutputParam(key: "epic_id")
        public var epic: Int?
        
        /// Return issues with the specified health_status.
        @OutputParam(key: "health_status")
        public var healthStatus: InputParams.HealthStatus?
        
        /// Return only the issues having the given iid.
        @OutputParam(key: "iids")
        public var iids: [Int]?
        
        /// Modify the scope of the search attribute.
        @OutputParam(key: "in")
        public var `in`: InputParams.SearchInScope?
        
        /// Filter to a given type of issue.
        @OutputParam(key: "issue_type")
        public var issueType: InputParams.IssueType?
        
        /// Return issues assigned to the given iteration ID.
        /// Mutually exclusive with `iteration_title`.
        @OutputParam(key: "iteration_id")
        public var iterationId: Int?
        
        /// Return issues assigned to the iteration with the given title.
        /// Mutually exclusive with `iteration_id`.
        @OutputParam(key: "iteration_title")
        public var iterationTitle: String?
        
        /// Filter by issues with labels.
        @OutputParam(key: "labels")
        public var labels: InputParams.LabelsSearch?
        
        /// Returns issues assigned to milestones with a given timebox value.
        @OutputParam(key: "milestone_id")
        public var milestoneId: InputParams.MilestoneIDSearch?
        
        /// Return issues reacted by the authenticated user by the given emoji.
        @OutputParam(key: "my_reaction_emoji")
        public var myReactionEmoji: InputParams.EmojiSearch?
        
        /// Return issues only from non-archived projects (by default is `true`).
        /// When `false`, the response returns issues from both archived and non-archived projects.
        @OutputParam(key: "non_archived")
        public var nonArchived: Bool?
        
        //@OutputParam(key: "not") public var not
        
        /// Set the order of returned issues.
        @OutputParam(key: "order_by")
        public var orderBy: InputParams.IssuesOrder?
        
        /// Return issues for the given scope. Default is `created_by_me`.
        @OutputParam(key: "scope")
        public var scope: InputParams.IssuesScope?
        
        /// Search issues against their `title` and `description`.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Return issues sorted in asc or desc order.
        @OutputParam(key: "sort")
        public var sort: InputParams.Sort?
        
        /// Return all issues or just those that are opened or closed.
        @OutputParam(key: "state")
        public var state: InputParams.IssuesState?
        
        /// Return issues updated on or after the given time.
        @OutputParam(key: "updated_after")
        public var updatedAfter: Date?
        
        /// Return issues updated on or before the given time.
        @OutputParam(key: "updated_before")
        public var updatedBefore: Date?
        
        /// Return issues with the specified weight.
        @OutputParam(key: "weight")
        public var weight: InputParams.IssuesWeight?
        
        /// If `true`, the response returns more details for each label in labels field.
        @OutputParam(key: "with_labels_details")
        public var withLabelsDetails: Bool?
        
        // MARK: - Initialization
        
        public init(_ configure: ((ListOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
