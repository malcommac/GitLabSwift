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
    
    public class ProjectNew: APIOptionsCollection {
        
        /// The name of the new project. Equals path if not provided.
        ///
        /// NOTE: Required if path isn’t provided.
        @APIOption(key: "name") public var name: String?
        
        /// Repository name for new project. Generated based on name if not provided (generated as lowercase with dashes).
        /// Starting with GitLab 14.9, path must not start or end with a special character and must
        /// not contain consecutive special characters.
        ///
        /// NOTE: if name isn’t provided.
        @APIOption(key: "path") public var path: String?
        
        /// Set whether or not merge requests can be merged with skipped jobs.
        @APIOption(key: "allow_merge_on_skipped_pipeline") public var allowMergeOnSkippedPipeline: Bool?
        
        /// Indicates that merges of merge requests should be blocked unless all status checks have passed.
        /// Defaults to false.
        /// Introduced in GitLab 15.5 with feature flag `only_allow_merge_if_all_status_checks_passed`
        /// disabled by default.
        @APIOption(key: "only_allow_merge_if_all_status_checks_passed") public var mergeAllowedOnlyOKStatusChecks: Bool?
        
        /// One of `disabled`, `private` or `enabled`
        @APIOption(key: "analytics_access_level") public var analyticsAccessLevel: DataTypes.AccessLevelFlag?
        
        /// How many approvers should approve merge requests by default.
        @APIOption(key: "approvals_before_merge") public var approvalsBeforeMerge: Int?
        
        /// Auto-cancel pending pipelines. This isn’t a boolean, but enabled/disabled.
        @APIOption(key: "auto_cancel_pending_pipelines") public var autoCancelPendingPipelines: DataTypes.Flag?
        
        /// Auto Deploy strategy.
        @APIOption(key: "auto_devops_deploy_strategy") public var deployStrategy: DataTypes.DeployStrategy?
        
        /// Enable Auto DevOps for this project.
        @APIOption(key: "auto_devops_enabled") public var autoDevOps: Bool?
        
        /// Set whether auto-closing referenced issues on default branch.
        @APIOption(key: "autoclose_referenced_issues") public var autoCloseRefIssues: Bool?
        
        // TODO: TBI
        // @APIOption(key: "avatar")
        
        /// The Git strategy. Defaults to `fetch`.
        @APIOption(key: "build_git_strategy") public var buildStrategy: String?
        
        /// The maximum amount of time, in seconds, that a job can run.
        @APIOption(key: "build_timeout") public var buildTimeout: Int?
        
        /// Auto-cancel pending pipelines. This isn’t a boolean, but enabled/disabled.
        @APIOption(key: "builds_access_level") public var buildAccessLevel: DataTypes.AccessLevelFlag?

        // to finish
    }
    
    public class ForksSearchOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// Limit by archived status.
        @APIOption(key: "archived")
        public var archived: Bool?
        
        /// Limit by projects that the current user is a member of.
        @APIOption(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role (`access_level`).
        @APIOption(key: "min_access_level")
        public var minAccessLevel: DataTypes.AccessLevel?
        
        /// Ordered of items returned by the query.
        @APIOption(key: "order_by")
        public var orderBy: DataTypes.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @APIOption(key: "owned")
        public var owned: Bool?
        
        /// Return list of projects matching the search criteria.
        @APIOption(key: "search")
        public var search: String?
        
        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only `simple` fields are returned.
        @APIOption(key: "simple")
        public var simple: Bool?
        
        /// Return projects sorted in `asc` or `desc` order. Default is `desc`.
        @APIOption(key: "sort")
        public var sort: DataTypes.Sort?
        
        /// Limit by projects starred by the current user.
        @APIOption(key: "starred")
        public var starred: Bool?
        
        /// Include project statistics. Only available to `Reporter` or higher level role members.
        @APIOption(key: "statistics")
        public var statistics: Bool?
        
        /// Limit by visibility.
        @APIOption(key: "visibility")
        public var visibility: DataTypes.ProjectVisibility?
        
        /// Include custom attributes in response. (`administrators` only).
        @APIOption(key: "with_custom_attributes")
        public var includeCustomAttributes: Bool?
        
        /// Limit by enabled issues feature.
        @APIOption(key: "with_issues_enabled")
        public var onlyWithIssuesEnabled: Bool?
        
        /// Limit by enabled merge requests feature.
        @APIOption(key: "with_merge_requests_enabled")
        public var onlyWithMRsEnabled: Bool?
        
        public init(project: DataTypes.ProjectID,
                    _ configure: ((ForksSearchOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
    public class ForkOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The description assigned to the resultant project after forking.
        @APIOption(key: "description")
        public var description: String?
        
        /// For forked projects, target merge requests to this project.
        /// If false, the target will be the upstream project.
        @APIOption(key: "mr_default_target_self")
        public var mrDefaultTargetSelf: Bool?
        
        /// The name assigned to the resultant project after forking.
        @APIOption(key: "name")
        public var name: String?
        
        /// The ID of the namespace that the project is forked to.
        @APIOption(key: "namespace_id")
        public var namespaceId: Int?
        
        /// The path of the namespace that the project is forked to.
        @APIOption(key: "namespace_path")
        public var namespacePath: String?
        
        /// The path assigned to the resultant project after forking.
        @APIOption(key: "path")
        public var path: String?
        
        /// The visibility level assigned to the resultant project after forking.
        @APIOption(key: "visibility")
        public var visibility: DataTypes.ProjectVisibility?
        
        public init(project: DataTypes.ProjectID,
                    _ configure: ((ForkOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
    }
        
    public class ProjectGroupsOptions: APIOptionsCollection {
    
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// Search for specific groups.
        @APIOption(key: "search")
        public var search: String?
        
        /// Limit to shared groups with at least this role .
        @APIOption(key: "shared_min_access_level")
        public var minAccessLevel: DataTypes.AccessLevel?

        /// Limit to shared groups user has access to.
        @APIOption(key: "shared_visible_only")
        public var visibleOnly: Bool?

        /// Skip the group IDs passed.
        @APIOption(key: "skip_groups")
        public var skipGroups: [Int]?
        
        /// Include projects shared with this group. Default is false.
        @APIOption(key: "with_shared")
        public var withShared: Bool?

        public init(project: DataTypes.ProjectID,
                    _ configure: ((ProjectGroupsOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
        
    public class ProjectUsersOptions: APIOptionsCollection {
    
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// Search for specific users.
        @APIOption(key: "search")
        public var search: String?
        
        /// Filter out users with the specified IDs.
        @APIOption(key: "skip_users")
        public var skipUsers: [Int]?

        public init(project: DataTypes.ProjectID,
                    _ configure: ((ProjectUsersOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
    
    public class SearchProjectOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?

        /// Include project license data.
        @APIOption(key: "license")
        public var license: Bool?
        
        /// Include project statistics. Only available to Reporter or higher level role members.
        @APIOption(key: "statistics")
        public var statistics: Bool?

        /// Include custom attributes in response. (administrators only)
        @APIOption(key: "with_custom_attributes")
        public var withCustomAttributes: Bool?
     
        public init(project: DataTypes.ProjectID,
                    _ configure: ((SearchProjectOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
        
    public class UserProjectsOptions: APIOptionsCollection {
        
        /// The ID or username of the user.
        @APIOption(key: "user_id")
        public var user: Int?
        
        /// Limit by archived status.
        @APIOption(key: "archived")
        public var archived: Bool?
        
        /// Limit results to projects with IDs greater than the specified ID.
        @APIOption(key: "id_after")
        public var idAfter: Bool?

        /// Limit results to projects with IDs less than the specified ID.
        @APIOption(key: "id_before")
        public var idBefore: Bool?

        /// Limit by projects that the current user is a member of.
        @APIOption(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role.
        @APIOption(key: "min_access_levelmbership")
        public var accessLevel: DataTypes.AccessLevel?
        
        /// Return projects ordered by value.
        @APIOption(key: "order_by")
        public var orderBy: DataTypes.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @APIOption(key: "owned")
        public var owned: Bool?

        /// Return list of projects matching the search criteria.
        @APIOption(key: "search")
        public var search: String?
        
        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only simple fields are returned.
        @APIOption(key: "simple")
        public var simple: Bool?
        
        /// Return projects sorted in asc or desc order.
        @APIOption(key: "sort")
        public var sort: DataTypes.Sort?

        /// Limit by projects starred by the current user.
        @APIOption(key: "starred")
        public var starred: Bool?
        
        /// Include project statistics.
        /// Only available to Reporter or higher level role members.
        @APIOption(key: "statistics")
        public var statistics: Bool?

        /// Limit by visibility.
        @APIOption(key: "visibility")
        public var visibility: DataTypes.ProjectVisibility?
        
        public init(user: Int,
                    _ configure: ((UserProjectsOptions) -> Void)?) {
            super.init()
            self.user = user
            configure?(self)
        }
        
    }
        
    public class SearchOptions: APIOptionsCollection {
        
        /// The ID or username of the user.
        @APIOption(key: "user_id")
        public var user: Int?
        
        /// Limit by archived status.
        @APIOption(key: "archived")
        public var archived: Bool?
        
        /// Limit results to projects with IDs greater than the specified ID.
        @APIOption(key: "id_after")
        public var idAfter: Bool?

        /// Limit results to projects with IDs less than the specified ID.
        @APIOption(key: "id_before")
        public var idBefore: Bool?

        /// Limit results to projects which were imported from external systems by current user.
        @APIOption(key: "imported")
        public var imported: Bool?
        
        /// Limit results to projects with last activity after specified time.
        @APIOption(key: "last_activity_after")
        public var lastActivityAfter: Date?

        /// Limit results to projects with last activity before specified time.
        @APIOption(key: "last_activity_before")
        public var lastActivityBefore: Date?

        /// Limit by projects that the current user is a member of.
        @APIOption(key: "membership")
        public var membership: Bool?
        
        /// Limit by current user minimal role.
        @APIOption(key: "min_access_levelmbership")
        public var accessLevel: DataTypes.AccessLevel?
        
        /// Return projects ordered by value.
        @APIOption(key: "order_by")
        public var orderBy: DataTypes.ProjectOrder?
        
        /// Limit by projects explicitly owned by the current user.
        @APIOption(key: "owned")
        public var owned: Bool?

        /// Limit projects where the repository checksum calculation has failed.
        @APIOption(key: "repository_checksum_failed")
        public var repositoryChecksumFailed: String?
        
        /// Limit results to projects stored on repository_storage (administrators only).
        @APIOption(key: "repository_storage")
        public var repositoryStorage: String?

        /// Include ancestor namespaces when matching search criteria. Default is false.
        @APIOption(key: "search_namespaces")
        public var searchNamespaces: Bool?

        /// Return list of projects matching the search criteria.
        @APIOption(key: "search")
        public var search: String?

        /// Return only limited fields for each project.
        /// This is a no-op without authentication where only simple fields are returned.
        @APIOption(key: "simple")
        public var simple: Bool?
                                            
        /// Return projects sorted in asc or desc order.
        @APIOption(key: "sort")
        public var sort: DataTypes.Sort?

        /// Limit by projects starred by the current user.
        @APIOption(key: "starred")
        public var starred: Bool?

        /// Include project statistics.
        /// Only available to Reporter or higher level role members.
        @APIOption(key: "statistics")
        public var statistics: Bool?

        /// Comma-separated topic names.
        /// Limit results to projects that match all of given topics.
        @APIOption(key: "topic")
        public var topic: String?

        /// Limit results to projects with the assigned topic given by the topic ID.
        @APIOption(key: "topic_id")
        public var topicId: Int?

        /// Limit by visibility.
        @APIOption(key: "visibility")
        public var visibility: DataTypes.ProjectVisibility?

        /// Limit projects where the wiki checksum calculation has failed.
        @APIOption(key: "wiki_checksum_failed")
        public var wikiChecksumFailed: Bool?

        /// Include custom attributes in response. (administrator only)
        @APIOption(key: "with_custom_attributes")
        public var withCustomAttributes: Bool?

        /// Limit by enabled issues feature.
        @APIOption(key: "with_issues_enabled")
        public var withIssuesEnabled: Bool?

        /// Limit by enabled merge requests feature.
        @APIOption(key: "with_merge_requests_enabled")
        public var withMergeRequestsEnabled: Bool?

        /// Limit by projects which use the given programming language.
        @APIOption(key: "with_programming_language")
        public var withProgrammingLanguage: Bool?

        public init(_ configure: ((SearchOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
