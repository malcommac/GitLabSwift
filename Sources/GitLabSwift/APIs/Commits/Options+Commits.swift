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
    
    public class CommitStatusOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The commit SHA.
        @OutputParam(key: "sha")
        public var sha: String?
        
        /// The name of a repository branch or tag or, if not given, the default branch
        @OutputParam(key: "ref")
        public var ref: String?
        
        /// Filter by build stage, for example, `test`.
        @OutputParam(key: "stage")
        public var stage: String?
        
        /// Filter by job name, for example, `bundler:audit`.
        @OutputParam(key: "name")
        public var name: String?
        
        /// Return all statuses, not only the latest ones
        @OutputParam(key: "all")
        public var all: Bool?
        
        public init(sha: String,
                    project: InputParams.Project,
                    _ configure: ((CommitStatusOptions) -> Void)?) {
            super.init()
            self.sha = sha
            self.project = project
            configure?(self)
        }
        
    }
    
    public class PostCommentOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The commit SHA or name of a repository branch or tag
        @OutputParam(key: "sha")
        public var sha: String?
    
        /// The text of the comment
        @OutputParam(key: "note")
        public var note: String?
        
        /// The file path relative to the repository
        @OutputParam(key: "path")
        public var path: String?
        
        /// The line number where the comment should be placed
        @OutputParam(key: "line")
        public var line: Int?
        
        /// The line type. Takes new or old as arguments.
        @OutputParam(key: "line_type")
        public var line_type: InputParams.CommitCommentLineType?
        
        public init(sha: String,
                    project: InputParams.Project,
                    _ configure: ((PostCommentOptions) -> Void)?) {
            super.init()
            self.sha = sha
            self.project = project
            configure?(self)
        }
        
    }
    
    public class CherryPickOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The commit hash
        @OutputParam(key: "sha")
        public var sha: String?
        
        /// The name of the branch
        @OutputParam(key: "branch")
        public var branch: String?
        
        /// Does not commit any changes. Default is false. Introduced in GitLab 13.3
        @OutputParam(key: "dry_run")
        public var dryRun: Bool?
        
        /// A custom commit message to use for the new commit. Introduced in GitLab 14.0
        @OutputParam(key: "message")
        public var message: String?
        
        public init(sha: String,
                    branch: String,
                    project: InputParams.Project,
                    _ configure: ((CherryPickOptions) -> Void)?) {
            super.init()
            self.project = project
            self.sha = sha
            self.branch = branch
            configure?(self)
        }
        
    }
    
    public class ListOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The name of a repository branch, tag or revision range, or if not given the default branch
        @OutputParam(key: "ref_name")
        public var refName: String?
        
        /// Only commits after or on this date are returned.
        @OutputParam(key: "since")
        public var since: Date?
        
        /// Only commits before or on this date are returned.
        @OutputParam(key: "until")
        public var until: Date?
        
        /// The file path.
        @OutputParam(key: "path")
        public var path: String?
        
        /// Retrieve every commit from the repository.
        @OutputParam(key: "all")
        public var all: Bool?
        
        /// Stats about each commit are added to the response.
        @OutputParam(key: "with_stats")
        public var includeStats: Bool?
        
        /// Follow only the first parent commit upon seeing a merge commit.
        @OutputParam(key: "first_parent")
        public var firstParent: Bool?
        
        /// List commits in order.
        @OutputParam(key: "first_parent")
        public var order: InputParams.CommitOrder?
        
        /// Parse and include Git trailers for every commit.
        @OutputParam(key: "trailers")
        public var includeTrailers: Bool?
        
        public init(project: InputParams.Project,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
