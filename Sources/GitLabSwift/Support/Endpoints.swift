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
import RealHTTP

// MARK: - Endpoint Path

/// Represent a convertible endpoint.
public protocol EndpointConvertible {
    
    /// The raw endpoint path. It may contains variable for parameters
    /// expressed as `{variable_name}`.
    var value: String { get }

}

extension String: EndpointConvertible {
    
    public var value: String {
        self
    }
    
}

public enum Endpoints: String, EndpointConvertible {
    
    public enum GroupLabels: String, EndpointConvertible {
        case list = "/groups/{id}/labels"
        case get = "/groups/{id}/labels/{label_id}"
        case subscribe = "/groups/{id}/labels/{label_id}/subscribe"
        case unsubscribe = "/groups/{id}/labels/{label_id}/unsubscribe"

        public var value: String { rawValue }
    }
    
    public enum Jobs: String, EndpointConvertible {
        case list = "/projects/{id}/jobs"
        case pipeline = "/projects/{id}/pipelines/{pipeline_id}/jobs"
        case single = "/projects/{id}/jobs/{job_id}"
        case cancel = "/projects/{id}/jobs/{job_id}/cancel"
        case retry = "/projects/{id}/jobs/{job_id}/retry"
        case erase = "/projects/{id}/jobs/{job_id}/erase"
        case play = "/projects/{id}/jobs/{job_id}/play"

        public var value: String { rawValue }
    }
    
    public enum IssuesStatistics: String, EndpointConvertible {
        case list = "/issues_statistics"
        case groups = "/groups/{id}/issues_statistics"
        case project = "/projects/{id}/issues_statistics"

        public var value: String { rawValue }
    }
    
    public enum EpicIssues: String, EndpointConvertible {
        case list = "/groups/{id}/epics/{epic_iid}/issues"
        case assign = "/groups/{id}/epics/{epic_iid}/issues/{issue_id}"
        case epicIssueId = "/groups/{id}/epics/{epic_iid}/issues/{epic_issue_id}"
        
        public var value: String { rawValue }
    }
    
    public enum Issues: String, EndpointConvertible {
        case list = "/issues"
        case listGroups = "/groups/{id}/issues"
        case listProjects = "/projects/{id}/issues"
        case get = "/issues/{id}"
        case getInProject = "/projects/{id}/issues/{issue_iid}"
        case reorder = "/projects/{id}/issues/{issue_iid}/reorder"
        case move = "/projects/{id}/issues/{issue_iid}/move"
        case clone = "/projects/{id}/issues/{issue_iid}/clone"
        case subscribe = "/projects/{id}/issues/{issue_iid}/subscribe"
        case unsubscribe = "/projects/{id}/issues/{issue_iid}/unsubscribe"
        case todo = "/projects/{id}/issues/{issue_iid}/todo"
        case notes = "/projects/{id}/issues/{issue_iid}/notes"
        case timeEstimate = "/projects/{id}/issues/{issue_iid}/time_estimate"
        case resetTimeEstimate = "/projects/{id}/issues/{issue_iid}/reset_time_estimate"
        case addSpentTime = "/projects/{id}/issues/{issue_iid}/add_spent_time"
        case resetSpentTime = "/projects/{id}/issues/{issue_iid}/reset_spent_time"
        case timeStats = "/projects/{id}/issues/{issue_iid}/time_stats"
        case relatedMergeRequests = "/projects/{id}/issues/{issue_iid}/related_merge_requests"
        case closedBy = "/projects/{id}/issues/{issue_iid}/closed_by"
        case participants = "/projects/{id}/issues/{issue_iid}/participants"
        case userAgentDetail = "/projects/{id}/issues/{issue_iid}/user_agent_detail"

        public var value: String { rawValue }
    }
    
    public enum Branches: String, EndpointConvertible {
        case list = "/projects/{id}/repository/branches"
        case protectedList = "/projects/{id}/protected_branches"
        case detail = "/projects/{id}/repository/branches/{branch}"
        case detailProtected = "/projects/{id}/protected_branches/{branch}"
        case mergedBranches = "/projects/{id}/repository/merged_branches"

        public var value: String { rawValue }
    }
    
    public enum GroupMilestones: String, EndpointConvertible {
        case list = "/groups/{id}/milestones"
        case get = "/groups/{id}/milestones/{milestone_id}"
        case issues = "/groups/{id}/milestones/{milestone_id}/issues"
        case mergeRequests = "/groups/{id}/milestones/{milestone_id}/merge_requests"

        public var value: String { rawValue }
    }
    
    public enum Pipelines: String, EndpointConvertible {
        case list = "/projects/{id}/pipelines"
        case get = "/projects/{id}/pipelines/{pipeline_id}"
        case variables = "/projects/{id}/pipelines/{pipeline_id}/variables"
        case test_report = "/projects/{id}/pipelines/{pipeline_id}/test_report"
        case test_report_summary = "/projects/{id}/pipelines/{pipeline_id}/test_report_summary"
        case latest = "/projects/{id}/pipelines/latest"
        case create = "/projects/{id}/pipeline"
        case retry = "/projects/{id}/pipelines/{pipeline_id}/retry"
        case cancel = "/projects/{id}/pipelines/{pipeline_id}/cancel"

        public var value: String { rawValue }
    }
    
    public enum Milestones: String, EndpointConvertible {
        case milestones = "/projects/{id}/milestones"
        case milestoneId = "/projects/{id}/milestones/{milestone_id}"
        case issues = "/projects/{id}/milestones/{milestone_id}/issues"
        case mergeRequests = "/projects/{id}/milestones/{milestone_id}/merge_requests"
        case promote = "/projects/{id}/milestones/{milestone_id}/promote"

        public var value: String { rawValue }
    }
    
    case userFromId = "/users/{id}"
    case users = "/users"
    case user = "/user"
    case userStatus = "/user/status"
    
    public enum Avatar: String, EndpointConvertible {
        case get = "/avatar"
        
        public var value: String { rawValue }
    }
    
    public enum Tags: String, EndpointConvertible {
        case list = "/projects/{id}/repository/tags"
        case get = "/projects/{id}/repository/tags/{tag_name}"
        
        public var value: String { rawValue }
    }
        
    public enum RepositoryFiles: String, EndpointConvertible {
        case get = "/projects/{id}/repository/files/{file_path}"
        case blame = "/projects/{id}/repository/files/{file_path}/blame"
        case raw = "/projects/{id}/repository/files/{file_path}/raw"

        public var value: String { rawValue }
    }
    
    public enum Repositories: String, EndpointConvertible {
        case tree = "/projects/{id}/repository/tree"
        case blob = "/projects/{id}/repository/blobs/{sha}"
        case blobRaw = "/projects/{id}/repository/blobs/{sha}/raw"
        case archive = "/projects/{id}/repository/archive{format}"
        case compare = "/projects/{id}/repository/compare"
        case contributors = "/projects/{id}/repository/contributors"
        case mergeBase = "/projects/{id}/repository/merge_base"
        case changelog = "/projects/{id}/repository/changelog"

        public var value: String { rawValue }
    }
    
    public enum Projects: String, EndpointConvertible {
        case all = "/projects"
        case users = "/projects/{id}/users"
        case groups = "/projects/{id}/groups"
        case detail = "/projects/{id}"
        case starred_projects = "/users/{user_id}/starred_projects"
        case user_projects = "/users/{user_id}/projects"
        case fork = "/projects/{id}/fork"
        case star = "/projects/{id}/star"
        case unstar = "/projects/{id}/unstar"
        case languages = "/projects/{id}/languages"
        case starrers = "/projects/{id}/starrers"
        case archive = "/projects/{id}/archive"
        case unarchive = "/projects/{id}/unarchive"
        case upload = "/projects/{id}/uploads"

        public var value: String { rawValue }
    }

    public enum Commits: String, EndpointConvertible {
        case commits = "/projects/{id}/repository/commits"
        case detail = "/projects/{id}/repository/commits/{sha}"
        case diff = "/projects/{id}/repository/commits/{sha}/diff"
        case comments = "/projects/{id}/repository/commits/{sha}/comments"
        case ref = "/projects/{id}/repository/commits/{sha}/refs"
        case discussions = "/projects/{id}/repository/commits/{sha}/discussions"
        case statuses = "/projects/{id}/repository/commits/{sha}/statuses"
        case mr = "/projects/{id}/repository/commits/{sha}/merge_requests"
        case gpg = "/projects/{id}/repository/commits/{sha}/signature"
        case cherryPick = "/projects/{id}/repository/commits/{sha}/cherry_pick"
        case revert = "/projects/{id}/repository/commits/{sha}/revert"

        public var value: String { rawValue }
    }
    
    public enum Discussions: String, EndpointConvertible {
        case discussions = "/projects/{id}/issues/{issue_iid}/discussions"
        case detail = "/projects/{id}/issues/{issue_iid}/discussions/{discussion_id}"
        case notes = "/projects/{id}/issues/{issue_iid}/discussions/{discussion_id}/notes"
        case snippet = "/projects/{id}/snippets/{snippet_id}/discussions"
        case snippetDiscussion = "/projects/{id}/snippets/{snippet_id}/discussions/{discussion_id}"
        case mergeRequests = "/projects/{id}/merge_requests/{merge_request_iid}/discussions"
        case mergeRequest = "/projects/{id}/merge_requests/{merge_request_iid}/discussions/{discussion_id}"

        public var value: String { rawValue }
    }
    
    case labels = "/projects/{id}/labels"
    case labels_single = "/projects/{id}/labels/{label_id}"
    case labels_promote = "/projects/{id}/labels/{label_id}/promote"
    case labels_subscribe = "/projects/{id}/labels/{label_id}/subscribe"
    case labels_unsubscribe = "/projects/{id}/labels/{label_id}/unsubscribe"

    public var value: String { rawValue }
    
}
