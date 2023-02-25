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

extension APIService.Commits {
    
    public class CommitStatusOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The commit SHA.
        @APIOption(key: "sha")
        public var sha: String?
        
        /// The name of a repository branch or tag or, if not given, the default branch
        @APIOption(key: "ref")
        public var ref: String?
        
        /// Filter by build stage, for example, `test`.
        @APIOption(key: "stage")
        public var stage: String?
        
        /// Filter by job name, for example, `bundler:audit`.
        @APIOption(key: "name")
        public var name: String?
        
        /// Return all statuses, not only the latest ones
        @APIOption(key: "all")
        public var all: Bool?
        
        public init(sha: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((CommitStatusOptions) -> Void)?) {
            super.init()
            self.sha = sha
            self.project = project
            configure?(self)
        }
        
    }
    
    public class PostCommentOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The commit SHA or name of a repository branch or tag
        @APIOption(key: "sha")
        public var sha: String?
    
        /// The text of the comment
        @APIOption(key: "note")
        public var note: String?
        
        /// The file path relative to the repository
        @APIOption(key: "path")
        public var path: String?
        
        /// The line number where the comment should be placed
        @APIOption(key: "line")
        public var line: Int?
        
        /// The line type. Takes new or old as arguments.
        @APIOption(key: "line_type")
        public var line_type: DataTypes.CommitCommentLineType?
        
        public init(sha: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((PostCommentOptions) -> Void)?) {
            super.init()
            self.sha = sha
            self.project = project
            configure?(self)
        }
        
    }
    
    public class CherryPickOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The commit hash
        @APIOption(key: "sha")
        public var sha: String?
        
        /// The name of the branch
        @APIOption(key: "branch")
        public var branch: String?
        
        /// Does not commit any changes. Default is false. Introduced in GitLab 13.3
        @APIOption(key: "dry_run")
        public var dryRun: Bool?
        
        /// A custom commit message to use for the new commit. Introduced in GitLab 14.0
        @APIOption(key: "message")
        public var message: String?
        
        public init(sha: String,
                    branch: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((CherryPickOptions) -> Void)?) {
            super.init()
            self.project = project
            self.sha = sha
            self.branch = branch
            configure?(self)
        }
        
    }
    
    public class ListOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The name of a repository branch, tag or revision range, or if not given the default branch
        @APIOption(key: "ref_name")
        public var refName: String?
        
        /// Only commits after or on this date are returned.
        @APIOption(key: "since")
        public var since: Date?
        
        /// Only commits before or on this date are returned.
        @APIOption(key: "until")
        public var until: Date?
        
        /// The file path.
        @APIOption(key: "path")
        public var path: String?
        
        /// Retrieve every commit from the repository.
        @APIOption(key: "all")
        public var all: Bool?
        
        /// Stats about each commit are added to the response.
        @APIOption(key: "with_stats")
        public var includeStats: Bool?
        
        /// Follow only the first parent commit upon seeing a merge commit.
        @APIOption(key: "first_parent")
        public var firstParent: Bool?
        
        /// List commits in order.
        @APIOption(key: "first_parent")
        public var order: DataTypes.CommitOrder?
        
        /// Parse and include Git trailers for every commit.
        @APIOption(key: "trailers")
        public var includeTrailers: Bool?
        
        public init(project: DataTypes.ProjectID,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
