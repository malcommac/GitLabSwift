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

extension APIOptions {
    
    public class EditIssue: APIOptionsCollection {
        
        // Comma-separated label names to add to an issue.
        @APIOption(key: "add_labels") public var addLabels: Int?
        
        /// The IDs of the users to assign the issue to.
        @APIOption(key: "assignee_ids") public var assigneeIds: [Int]?
        
        /// Set an issue to be confidential.
        @APIOption(key: "confidential") public var confidential: Bool?
        
        /// The description of an issue. Limited to 1,048,576 characters.
        @APIOption(key: "description") public var description: String?
        
        // Flag indicating if the issue’s discussion is locked.
        // If the discussion is locked only project members can add or edit comments.
        @APIOption(key: "discussion_locked") public var discussionLocked: Bool?
        
        /// The due date.
        @APIOption(key: "due_date") public var dueDate: Date?
        
        /// ID of the epic to add the issue to.
        @APIOption(key: "epic_id") public var epicId: Int?
        
        /// IID of the epic to add the issue to.
        @APIOption(key: "epic_iid") public var epicIid: Int?
        
        /// The project reference.
        @APIOption(key: "id") public var project: DataTypes.ProjectID?
        
        /// The internal ID of a project’s issue
        @APIOption(key: "issue_iid") public var issueIid: Int?
        
        /// The type of issue.
        @APIOption(key: "issue_type") public var issueType: DataTypes.IssueType?
        
        /// Comma-separated label names for an issue.
        @APIOption(key: "labels") public var labels: String?
        
        /// The global ID of a milestone to assign issue.
        @APIOption(key: "milestone_id") public var milestoneId: Int?
        
        /// The title of an issue.
        @APIOption(key: "title") public var title: String?
        
        /// When the issue was updated.
        @APIOption(key: "updated_at") public var updatedAt: Date?
        
        /// The weight of the issue.
        @APIOption(key: "weight") public var weight: Int?
        
        // MARK: - Initialization
        
        public init(iid: Int, project: DataTypes.ProjectID, _ configure: ((EditIssue) -> Void)?) {
            super.init()
            self.issueIid = iid
            self.project = project
            configure?(self)
        }
        
    }
    
    public class CreateIssue: APIOptionsCollection {
        
        // The ID of the user to assign the issue to. Only appears on GitLab Free.
        @APIOption(key: "assignee_id") public var assigneeId: Int?
        
        /// The IDs of the users to assign the issue to.
        @APIOption(key: "assignee_ids") public var assigneeIds: [Int]?
        
        /// Set an issue to be confidential.
        @APIOption(key: "confidential") public var confidential: Bool?
        
        /// When the issue was created.
        @APIOption(key: "created_at") public var createdAt: Date?
        
        /// The description of an issue. Limited to 1,048,576 characters.
        @APIOption(key: "description") public var description: String?
        
        /// The ID of a discussion to resolve
        @APIOption(key: "discussion_to_resolve") public var discussionToResolve: String?
        
        /// The due date.
        @APIOption(key: "due_date") public var dueDate: Date?
        
        /// ID of the epic to add the issue to.
        @APIOption(key: "epic_id") public var epicId: Int?
        
        /// IID of the epic to add the issue to.
        @APIOption(key: "epic_iid") public var epicIid: Int?
        
        /// The project reference.
        @APIOption(key: "id") public var project: DataTypes.ProjectID?
        
        /// The project reference iid.
        @APIOption(key: "iid") public var projectIid: Int?
        
        /// The type of issue.
        @APIOption(key: "issue_type") public var issueType: DataTypes.IssueType?
        
        /// Comma-separated label names for an issue.
        @APIOption(key: "labels") public var labels: String?
        
        /// The IID of a merge request in which to resolve all issues.
        @APIOption(key: "merge_request_to_resolve_discussions_of") public var mrToResolveDiscussionOf: Int?
        
        /// The global ID of a milestone to assign issue.
        @APIOption(key: "milestone_id") public var milestoneId: Int?
        
        /// The title of an issue.
        @APIOption(key: "title") public var title: String?
        
        /// The weight of the issue.
        @APIOption(key: "weight") public var weight: Int?
        
        // MARK: - Initialization
        
        public init(title: String, project: DataTypes.ProjectID, _ configure: ((CreateIssue) -> Void)?) {
            super.init()
            self.project = project
            self.title = title
            configure?(self)
        }
    
    }
    
    public class SearchProjectIssues: SearchIssues {
        
        /// Id of the group.
        @APIOption(key: "id") public var projectID: DataTypes.ProjectID?
        
        // MARK: - Initialization
        
        public init(id: DataTypes.ProjectID, _ configure: ((SearchProjectIssues) -> Void)?) {
            super.init(nil)
            self.projectID = id
            configure?(self)
        }
        
    }
    
    public class SearchGroupIssues: SearchIssues {
        
        /// Id of the group.
        @APIOption(key: "id") public var groupId: Int?
        
        // MARK: - Initialization
        
        public init(id: Int, _ configure: ((SearchGroupIssues) -> Void)?) {
            super.init(nil)
            self.groupId = id
            configure?(self)
        }
        
    }
        
    public class SearchIssues: APIOptionsCollection {
        
        /// Return issues assigned to the given user id.
        /// Mutually exclusive with assignee_username.
        /// None returns unassigned issues. Any returns issues with an assignee.
        @APIOption(key: "assignee_id") public var assigneeID: Int?
        
        /// Return issues assigned to the given username.
        @APIOption(key: "assignee_username") public var assigneeUsernames: [String]?
        
        /// Return issues created by the given user id.
        /// Mutually exclusive with `author_username`.
        /// Combine with `scope=all` or `scope=assigned_to_me`.
        @APIOption(key: "author_id") public var author: Int?
        
        /// Return issues created by the given username.
        /// Similar to `author_id` and mutually exclusive with `author_id`.
        @APIOption(key: "author_username") public var authorUsername: String?
        
        /// Filter confidential or public issues.
        @APIOption(key: "confidential") public var confidential: Bool?
        
        /// Return issues created on or after the given time.
        @APIOption(key: "created_after") public var createdAfter: Date?
        
        /// Return issues created on or before the given time.
        @APIOption(key: "created_before") public var createdBefore: Date?
        
        /// Return issues that have no due date, are overdue,
        /// or whose due date is this week, this month,
        /// or between two weeks ago and next month.
        @APIOption(key: "due_date") public var dueDate: DataTypes.DueDate?
        
        /// Return issues associated with the given epic ID.
        @APIOption(key: "epic_id") public var epic: Int?
        
        /// Return issues with the specified health_status.
        @APIOption(key: "health_status") public var healthStatus: DataTypes.HealthStatus?
        
        /// Return only the issues having the given iid.
        @APIOption(key: "iids") public var iids: [Int]?
        
        /// Modify the scope of the search attribute.
        @APIOption(key: "in") public var `in`: DataTypes.SearchInScope?
        
        /// Filter to a given type of issue.
        @APIOption(key: "issue_type") public var issueType: DataTypes.IssueType?
        
        /// Return issues assigned to the given iteration ID.
        /// Mutually exclusive with `iteration_title`.
        @APIOption(key: "iteration_id") public var iterationId: Int?
        
        /// Return issues assigned to the iteration with the given title.
        /// Mutually exclusive with `iteration_id`.
        @APIOption(key: "iteration_title") public var iterationTitle: String?
        
        /// Filter by issues with labels.
        @APIOption(key: "labels") public var labels: DataTypes.LabelsSearch?
        
        /// Returns issues assigned to milestones with a given timebox value.
        @APIOption(key: "milestone_id") public var milestoneId: DataTypes.MilestoneIDSearch?
        
        /// Return issues reacted by the authenticated user by the given emoji.
        @APIOption(key: "my_reaction_emoji") public var myReactionEmoji: DataTypes.EmojiSearch?
        
        /// Return issues only from non-archived projects (by default is `true`).
        /// When `false`, the response returns issues from both archived and non-archived projects.
        @APIOption(key: "non_archived") public var nonArchived: Bool?
        
        //@APIOption(key: "not") public var not
        
        /// Set the order of returned issues.
        @APIOption(key: "order_by") public var orderBy: DataTypes.IssuesOrder?
        
        /// Return issues for the given scope. Default is `created_by_me`.
        @APIOption(key: "scope") public var scope: DataTypes.IssuesScope?
        
        /// Search issues against their `title` and `description`.
        @APIOption(key: "search") public var search: String?
        
        /// Return issues sorted in asc or desc order.
        @APIOption(key: "sort") public var sort: DataTypes.Sort?
        
        /// Return all issues or just those that are opened or closed.
        @APIOption(key: "state") public var state: DataTypes.IssuesState?
        
        /// Return issues updated on or after the given time.
        @APIOption(key: "updated_after") public var updatedAfter: Date?
        
        /// Return issues updated on or before the given time.
        @APIOption(key: "updated_before") public var updatedBefore: Date?
        
        /// Return issues with the specified weight.
        @APIOption(key: "weight") public var weight: DataTypes.IssuesWeight?
        
        /// If `true`, the response returns more details for each label in labels field.
        @APIOption(key: "with_labels_details") public var withLabelsDetails: Bool?
        
        // MARK: - Initialization
        
        public init(_ configure: ((SearchIssues) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
