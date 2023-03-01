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

extension APIs.MergeRequests {
    
    public class ListOptions: OutputParamsCollection {
        
        /// Returns merge requests which have been approved by all the users with the given id.
        @OutputParam(key: "approved_by_ids")
        public var approvedByIds: [Int]?
        
        /// Returns merge requests which have specified all the users with the given id as individual approvers.
        @OutputParam(key: "approver_ids")
        public var approverIds: [Int]?
        
        /// Returns merge requests assigned to the given user id.
        /// - `None` returns unassigned merge requests.
        /// - `Any` returns merge requests with an assignee.
        @OutputParam(key: "assignee_id")
        public var assigneeId: Int?
        
        /// Returns merge requests created by the given user id.
        @OutputParam(key: "author_id")
        public var authorId: Int?
        
        /// Returns merge requests created by the given `username`. Mutually exclusive with `author_id`.
        @OutputParam(key: "author_username")
        public var authorUsername: String?
        
        /// Returns merge requests created on or after the given time.
        @OutputParam(key: "created_after")
        public var createdAfter: Date?
        
        /// Returns merge requests created on or before the given time.
        @OutputParam(key: "created_before")
        public var createdBefore: Date?
        
        /// Returns merge requests deployed after the given date/time.
        @OutputParam(key: "deployed_after")
        public var deployedAfter: Date?
        
        /// Returns merge requests deployed before the given date/time.
        @OutputParam(key: "deployed_before")
        public var deployedBefore: Date?
        
        /// Returns merge requests deployed to the given environment.
        @OutputParam(key: "environment")
        public var environment: String?
        
        /// Modify the scope of the search attribute.
        @OutputParam(key: "in")
        public var `in`: InputParams.SearchInScope?
        
        /// Returns merge requests matching a comma-separated list of labels.
        @OutputParam(key: "labels")
        public var labels: InputParams.LabelsSearch?
        
        /// Returns merge requests for a specific milestone.
        @OutputParam(key: "milestone")
        public var milestoneId: InputParams.MilestoneIDSearch?
        
        /// Returns merge requests reacted by the authenticated user by the given emoji.
        @OutputParam(key: "my_reaction_emoji")
        public var myReactionEmoji: InputParams.EmojiSearch?
        
        //@OutputParam(key: "not")
        //public var `not`: String?
        
        /// Returns requests ordered by value.
        @OutputParam(key: "order_by")
        public var orderBy: InputParams.MilestoneOrder?
        
        /// Returns merge requests which have the user as a reviewer with the given user id.
        @OutputParam(key: "reviewer_id")
        public var reviewerId: Int?
        
        /// Returns merge requests which have the user as a reviewer with the given username.
        @OutputParam(key: "reviewer_username")
        public var reviewerUsername: Int?
        
        /// Returns merge requests for the given scope.
        @OutputParam(key: "scope")
        public var scope: InputParams.MilestoneScope?
       
        /// Search merge requests against their title and description.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Returns requests sorted in asc or desc order.
        @OutputParam(key: "sort")
        public var sort: InputParams.Sort?
        
        /// Returns merge requests with the given source branch.
        @OutputParam(key: "source_branch")
        public var sourceBranch: String?
        
        /// Returns all merge requests or just those that are opened, closed, locked, or merged.
        @OutputParam(key: "state")
        public var state: InputParams.MilestoneStateList?

        /// Returns merge requests with the given target branch.
        @OutputParam(key: "target_branch")
        public var targetBranch: String?
       
        /// Returns merge requests updated on or after the given time.
        @OutputParam(key: "updated_after")
        public var updatedAfter: Date?
        
        /// Returns merge requests updated on or before the given time
        @OutputParam(key: "updated_before")
        public var updatedBefore: Date?
        
        /// If simple, returns the iid, URL, title, description, and basic state of merge request.
        @OutputParam(key: "view")
        public var view: String?
        
        /// If true, response returns more details for each label
        /// in labels field: :name, :color, :description, :description_html, :text_color.
        @OutputParam(key: "with_labels_details")
        public var withLabelsDetails: Bool?
        
        /// If true, this projection requests (but does not guarantee)
        /// that the merge_status field be recalculated asynchronously.
        @OutputParam(key: "with_merge_status_recheck")
        public var withMergeStatusRecheck: Bool?
        
        /// Filter merge requests against their wip status
        @OutputParam(key: "wip")
        public var wip: InputParams.MilestoneWip?
        
        public init(_ configure: ((ListOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
    public class SingleMROption: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user..
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The internal ID of the merge request.
        @OutputParam(key: "merge_request_iid")
        public var iid: Int?
        
        /// If true, response includes the commits behind the target branch.
        @OutputParam(key: "include_diverged_commits_count")
        public var includeDivergedCommitsCount: Bool?
        
        /// If true, response includes whether a rebase operation is in progress.
        @OutputParam(key: "include_rebase_in_progress")
        public var includeRebaseInProgress: Bool?
        
        /// If true, response includes rendered HTML for title and description.
        @OutputParam(key: "render_html")
        public var renderHTML: Bool?
        
        public init(iid: Int,
                    project: InputParams.Project,
                    _ configure: ((SingleMROption) -> Void)?) {
            super.init()
            self.project = project
            self.iid = iid
            configure?(self)
        }
        
    }
    
    public class MergeMROptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The internal ID of the merge request.
        @OutputParam(key: "merge_request_iid")
        public var mergeRequest: Int?
        
        /// Custom merge commit message.
        @OutputParam(key: "merge_commit_message")
        public var message: String?
        
        /// If true, the merge request is merged when the pipeline succeeds.
        @OutputParam(key: "merge_when_pipeline_succeeds")
        public var mergeWhenPipelineSucceeds: Bool?
        
        /// If present, then this SHA must match the HEAD of the source branch, otherwise the merge fails.
        @OutputParam(key: "sha")
        public var sha: String?
        
        /// If true, removes the source branch.
        @OutputParam(key: "should_remove_source_branch")
        public var removeSourceBranch: Bool?
        
        /// Custom squash commit message.
        @OutputParam(key: "squash_commit_message")
        public var squashCommitMessage: String?
        
        /// If true, the commits are squashed into a single commit on merge.
        @OutputParam(key: "squash")
        public var squash: Bool?
        
        public init(iid: Int,
                    project: InputParams.Project,
                    _ configure: ((MergeMROptions) -> Void)?) {
            super.init()
            self.project = project
            self.mergeRequest = iid
            configure?(self)
        }
        
    }
    
    public class CreateMROptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user..
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The source branch.
        @OutputParam(key: "source_branch")
        public var sourceBranch: String?
        
        /// The target branch.
        @OutputParam(key: "target_branch")
        public var targetBranch: String?
        
        /// Title of MR.
        @OutputParam(key: "title")
        public var title: String?
        
        /// Allow commits from members who can merge to the target branch.
        @OutputParam(key: "allow_collaboration")
        public var allowCollaboration: Bool?
        
        /// Number of approvals required before this can be merged (see below).
        @OutputParam(key: "approvals_before_merge")
        public var approvalsBeforeMerge: Bool?
        
        /// Assignee user ID.
        @OutputParam(key: "assignee_id")
        public var assigneeId: Bool?

        /// The ID of the users to assign the merge request to. Set to empty value to unassign all assignees.
        @OutputParam(key: "assignee_ids")
        public var allowColassigneeIds: [Int]?
        
        /// Description of the merge request. Limited to 1,048,576 characters.
        @OutputParam(key: "description")
        public var description: String?
        
        /// Labels for the merge request, as a comma-separated list.
        @OutputParam(key: "labels")
        public var labels: String?
        
        /// The global ID of a milestone.
        @OutputParam(key: "milestone_id")
        public var milestoneId: Int?
        
        /// Flag indicating if a merge request should remove the source branch when merging.
        @OutputParam(key: "remove_source_branch")
        public var removeSourceBranch: Bool?
        
        /// The ID of the users added as a reviewer to the merge request.
        @OutputParam(key: "reviewer_ids")
        public var reviewerIds: [Int]?
        
        /// Indicates if the merge request is set to be squashed when merged.
        @OutputParam(key: "squash")
        public var squash: Bool?
        
        /// Indicates if the merge request will be squashed when merged.
        @OutputParam(key: "squash_on_merge")
        public var squashOnMerge: Bool?
        
        /// Numeric ID of the target project.
        @OutputParam(key: "target_project_id")
        public var targetProjectId: Int?
        
        public init(project: InputParams.Project,
                    _ configure: ((CreateMROptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
