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

extension APIService.Projects {
    
    public class ProjectNew: OutputParamsCollection {
        
        /// The name of the new project. Equals path if not provided.
        ///
        /// NOTE: Required if path isn’t provided.
        @OutputParam(key: "name") public var name: String?
        
        /// Repository name for new project. Generated based on name if not provided (generated as lowercase with dashes).
        /// Starting with GitLab 14.9, path must not start or end with a special character and must
        /// not contain consecutive special characters.
        ///
        /// NOTE: if name isn’t provided.
        @OutputParam(key: "path") public var path: String?
        
        /// Set whether or not merge requests can be merged with skipped jobs.
        @OutputParam(key: "allow_merge_on_skipped_pipeline") public var allowMergeOnSkippedPipeline: Bool?
        
        /// Indicates that merges of merge requests should be blocked unless all status checks have passed.
        /// Defaults to false.
        /// Introduced in GitLab 15.5 with feature flag `only_allow_merge_if_all_status_checks_passed`
        /// disabled by default.
        @OutputParam(key: "only_allow_merge_if_all_status_checks_passed") public var mergeAllowedOnlyOKStatusChecks: Bool?
        
        /// One of `disabled`, `private` or `enabled`
        @OutputParam(key: "analytics_access_level") public var analyticsAccessLevel: InputParams.AccessLevelFlag?
        
        /// How many approvers should approve merge requests by default.
        @OutputParam(key: "approvals_before_merge") public var approvalsBeforeMerge: Int?
        
        /// Auto-cancel pending pipelines. This isn’t a boolean, but enabled/disabled.
        @OutputParam(key: "auto_cancel_pending_pipelines") public var autoCancelPendingPipelines: InputParams.Flag?
        
        /// Auto Deploy strategy.
        @OutputParam(key: "auto_devops_deploy_strategy") public var deployStrategy: InputParams.DeployStrategy?
        
        /// Enable Auto DevOps for this project.
        @OutputParam(key: "auto_devops_enabled") public var autoDevOps: Bool?
        
        /// Set whether auto-closing referenced issues on default branch.
        @OutputParam(key: "autoclose_referenced_issues") public var autoCloseRefIssues: Bool?
        
        // TODO: TBI
        // @OutputParam(key: "avatar")
        
        /// The Git strategy. Defaults to `fetch`.
        @OutputParam(key: "build_git_strategy") public var buildStrategy: String?
        
        /// The maximum amount of time, in seconds, that a job can run.
        @OutputParam(key: "build_timeout") public var buildTimeout: Int?
        
        /// Auto-cancel pending pipelines. This isn’t a boolean, but enabled/disabled.
        @OutputParam(key: "builds_access_level") public var buildAccessLevel: InputParams.AccessLevelFlag?

        // to finish
    }
    
    public class ForksSearchOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// Limit by archived status.
        @OutputParam(key: "archived")
        public var archived: Bool?
        
        /// Limit by projects that the current user is a member of.
        @OutputParam(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role (`access_level`).
        @OutputParam(key: "min_access_level")
        public var minAccessLevel: InputParams.AccessLevel?
        
        /// Ordered of items returned by the query.
        @OutputParam(key: "order_by")
        public var orderBy: InputParams.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @OutputParam(key: "owned")
        public var owned: Bool?
        
        /// Return list of projects matching the search criteria.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only `simple` fields are returned.
        @OutputParam(key: "simple")
        public var simple: Bool?
        
        /// Return projects sorted in `asc` or `desc` order. Default is `desc`.
        @OutputParam(key: "sort")
        public var sort: InputParams.Sort?
        
        /// Limit by projects starred by the current user.
        @OutputParam(key: "starred")
        public var starred: Bool?
        
        /// Include project statistics. Only available to `Reporter` or higher level role members.
        @OutputParam(key: "statistics")
        public var statistics: Bool?
        
        /// Limit by visibility.
        @OutputParam(key: "visibility")
        public var visibility: InputParams.ProjectVisibility?
        
        /// Include custom attributes in response. (`administrators` only).
        @OutputParam(key: "with_custom_attributes")
        public var includeCustomAttributes: Bool?
        
        /// Limit by enabled issues feature.
        @OutputParam(key: "with_issues_enabled")
        public var onlyWithIssuesEnabled: Bool?
        
        /// Limit by enabled merge requests feature.
        @OutputParam(key: "with_merge_requests_enabled")
        public var onlyWithMRsEnabled: Bool?
        
        public init(project: InputParams.ProjectID,
                    _ configure: ((ForksSearchOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
    public class ForkOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The description assigned to the resultant project after forking.
        @OutputParam(key: "description")
        public var description: String?
        
        /// For forked projects, target merge requests to this project.
        /// If false, the target will be the upstream project.
        @OutputParam(key: "mr_default_target_self")
        public var mrDefaultTargetSelf: Bool?
        
        /// The name assigned to the resultant project after forking.
        @OutputParam(key: "name")
        public var name: String?
        
        /// The ID of the namespace that the project is forked to.
        @OutputParam(key: "namespace_id")
        public var namespaceId: Int?
        
        /// The path of the namespace that the project is forked to.
        @OutputParam(key: "namespace_path")
        public var namespacePath: String?
        
        /// The path assigned to the resultant project after forking.
        @OutputParam(key: "path")
        public var path: String?
        
        /// The visibility level assigned to the resultant project after forking.
        @OutputParam(key: "visibility")
        public var visibility: InputParams.ProjectVisibility?
        
        public init(project: InputParams.ProjectID,
                    _ configure: ((ForkOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
    }
        
    public class ProjectGroupsOptions: OutputParamsCollection {
    
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// Search for specific groups.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Limit to shared groups with at least this role .
        @OutputParam(key: "shared_min_access_level")
        public var minAccessLevel: InputParams.AccessLevel?

        /// Limit to shared groups user has access to.
        @OutputParam(key: "shared_visible_only")
        public var visibleOnly: Bool?

        /// Skip the group IDs passed.
        @OutputParam(key: "skip_groups")
        public var skipGroups: [Int]?
        
        /// Include projects shared with this group. Default is false.
        @OutputParam(key: "with_shared")
        public var withShared: Bool?

        public init(project: InputParams.ProjectID,
                    _ configure: ((ProjectGroupsOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
        
    public class ProjectUsersOptions: OutputParamsCollection {
    
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// Search for specific users.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Filter out users with the specified IDs.
        @OutputParam(key: "skip_users")
        public var skipUsers: [Int]?

        public init(project: InputParams.ProjectID,
                    _ configure: ((ProjectUsersOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
    
    public class SearchProjectOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?

        /// Include project license data.
        @OutputParam(key: "license")
        public var license: Bool?
        
        /// Include project statistics. Only available to Reporter or higher level role members.
        @OutputParam(key: "statistics")
        public var statistics: Bool?

        /// Include custom attributes in response. (administrators only)
        @OutputParam(key: "with_custom_attributes")
        public var withCustomAttributes: Bool?
     
        public init(project: InputParams.ProjectID,
                    _ configure: ((SearchProjectOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
        
    public class UserProjectsOptions: OutputParamsCollection {
        
        /// The ID or username of the user.
        @OutputParam(key: "user_id")
        public var user: Int?
        
        /// Limit by archived status.
        @OutputParam(key: "archived")
        public var archived: Bool?
        
        /// Limit results to projects with IDs greater than the specified ID.
        @OutputParam(key: "id_after")
        public var idAfter: Bool?

        /// Limit results to projects with IDs less than the specified ID.
        @OutputParam(key: "id_before")
        public var idBefore: Bool?

        /// Limit by projects that the current user is a member of.
        @OutputParam(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role.
        @OutputParam(key: "min_access_levelmbership")
        public var accessLevel: InputParams.AccessLevel?
        
        /// Return projects ordered by value.
        @OutputParam(key: "order_by")
        public var orderBy: InputParams.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @OutputParam(key: "owned")
        public var owned: Bool?

        /// Return list of projects matching the search criteria.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only simple fields are returned.
        @OutputParam(key: "simple")
        public var simple: Bool?
        
        /// Return projects sorted in asc or desc order.
        @OutputParam(key: "sort")
        public var sort: InputParams.Sort?

        /// Limit by projects starred by the current user.
        @OutputParam(key: "starred")
        public var starred: Bool?
        
        /// Include project statistics.
        /// Only available to Reporter or higher level role members.
        @OutputParam(key: "statistics")
        public var statistics: Bool?

        /// Limit by visibility.
        @OutputParam(key: "visibility")
        public var visibility: InputParams.ProjectVisibility?
        
        public init(user: Int,
                    _ configure: ((UserProjectsOptions) -> Void)?) {
            super.init()
            self.user = user
            configure?(self)
        }
        
    }
        
    public class SearchOptions: OutputParamsCollection {
        
        /// The ID or username of the user.
        @OutputParam(key: "user_id")
        public var user: Int?
        
        /// Limit by archived status.
        @OutputParam(key: "archived")
        public var archived: Bool?
        
        /// Limit results to projects with IDs greater than the specified ID.
        @OutputParam(key: "id_after")
        public var idAfter: Bool?

        /// Limit results to projects with IDs less than the specified ID.
        @OutputParam(key: "id_before")
        public var idBefore: Bool?

        /// Limit results to projects which were imported from external systems by current user.
        @OutputParam(key: "imported")
        public var imported: Bool?
        
        /// Limit results to projects with last activity after specified time.
        @OutputParam(key: "last_activity_after")
        public var lastActivityAfter: Date?

        /// Limit results to projects with last activity before specified time.
        @OutputParam(key: "last_activity_before")
        public var lastActivityBefore: Date?

        /// Limit by projects that the current user is a member of.
        @OutputParam(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role.
        @OutputParam(key: "min_access_levelmbership")
        public var accessLevel: InputParams.AccessLevel?
        
        /// Return projects ordered by value.
        @OutputParam(key: "order_by")
        public var orderBy: InputParams.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @OutputParam(key: "owned")
        public var owned: Bool?

        /// Limit projects where the repository checksum calculation has failed.
        @OutputParam(key: "repository_checksum_failed")
        public var repositoryChecksumFailed: String?
        
        /// Limit results to projects stored on repository_storage (administrators only).
        @OutputParam(key: "repository_storage")
        public var repositoryStorage: String?

        /// Include ancestor namespaces when matching search criteria. Default is false.
        @OutputParam(key: "search_namespaces")
        public var searchNamespaces: Bool?

        /// Return list of projects matching the search criteria.
        @OutputParam(key: "search")
        public var search: String?

        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only simple fields are returned.
        @OutputParam(key: "simple")
        public var simple: Bool?
                                            
        /// Return projects sorted in asc or desc order.
        @OutputParam(key: "sort")
        public var sort: InputParams.Sort?

        /// Limit by projects starred by the current user.
        @OutputParam(key: "starred")
        public var starred: Bool?

        /// Include project statistics.
        /// Only available to Reporter or higher level role members.
        @OutputParam(key: "statistics")
        public var statistics: Bool?

        /// Comma-separated topic names.
        /// Limit results to projects that match all of given topics.
        @OutputParam(key: "topic")
        public var topic: String?

        /// Limit results to projects with the assigned topic given by the topic ID.
        @OutputParam(key: "topic_id")
        public var topicId: Int?

        /// Limit by visibility.
        @OutputParam(key: "visibility")
        public var visibility: InputParams.ProjectVisibility?

        /// Limit projects where the wiki checksum calculation has failed.
        @OutputParam(key: "wiki_checksum_failed")
        public var wikiChecksumFailed: Bool?

        /// Include custom attributes in response. (administrator only)
        @OutputParam(key: "with_custom_attributes")
        public var withCustomAttributes: Bool?

        /// Limit by enabled issues feature.
        @OutputParam(key: "with_issues_enabled")
        public var withIssuesEnabled: Bool?

        /// Limit by enabled merge requests feature.
        @OutputParam(key: "with_merge_requests_enabled")
        public var withMergeRequestsEnabled: Bool?

        /// Limit by projects which use the given programming language.
        @OutputParam(key: "with_programming_language")
        public var withProgrammingLanguage: Bool?

        public init(_ configure: ((SearchOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
