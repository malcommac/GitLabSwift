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

extension APIService.Repositories {
    
    public class NewChangelogOptions: OutputParamsCollection {
        
        /// The id of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
     
        /// The id of the project.
        @OutputParam(key: "version")
        public var version: String?
        
        /// The path of changelog configuration file.
        @OutputParam(key: "config_file")
        public var configFilePath: String?
        
        /// The date and time of the release.
        @OutputParam(key: "date")
        public var date: Date?
        
        /// The start of the range of commits.
        @OutputParam(key: "from")
        public var fromSha: String?
        
        /// The end of the range of commits.
        @OutputParam(key: "to")
        public var toSha: String?
        
        /// The Git trailer to use for including commits, defaults to Changelog.
        @OutputParam(key: "trailer")
        public var trailer: String?
        
        public init(version: String,
                    project: InputParams.ProjectID,
                    _ configure: ((NewChangelogOptions) -> Void)?) {
            super.init()
            self.project = project
            self.version = version
            configure?(self)
        }
    }
    
    public class ChangelogOptions: OutputParamsCollection {

        /// The id of the project.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The version to generate the changelog for. The format must follow semantic versioning.
        @OutputParam(key: "version")
        public var version: String?
        
        /// The branch to commit the changelog changes to.
        @OutputParam(key: "branch")
        public var branch: String?
        
        /// Path to the changelog configuration file in the project’s Git repository.
        @OutputParam(key: "config_file")
        public var configFilePath: String?
        
        /// The date and time of the release.
        @OutputParam(key: "date")
        public var date: Date?
        
        /// The file to commit the changes to. Defaults to CHANGELOG.md.
        @OutputParam(key: "file")
        public var outputFile: String?
        
        /// The SHA of the commit that marks the beginning of the range of commits to include in the changelog.
        @OutputParam(key: "from")
        public var fromSha: String?
        
        /// The commit message to use when committing the changes.
        @OutputParam(key: "message")
        public var message: String?
        
        /// The SHA of the commit that marks the end of the range of commits to include in the changelog.
        @OutputParam(key: "to")
        public var toSha: String?
        
        /// The Git trailer to use for including commits.
        @OutputParam(key: "trailer")
        public var trailer: String?

        public init(version: String,
                    project: InputParams.ProjectID,
                    _ configure: ((ChangelogOptions) -> Void)?) {
            super.init()
            self.project = project
            self.version = version
            configure?(self)
        }
        
    }
    
    public class ListOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated use.
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The tree record ID at which to fetch the next page.
        /// Used only with keyset pagination.
        @OutputParam(key: "page_token")
        public var pageToken: String?
        
        /// If keyset, use the keyset-based pagination method.
        @OutputParam(key: "pagination")
        public var pagination: String?

        /// The path inside the repository. Used to get content of subdirectories.
        @OutputParam(key: "path")
        public var path: String?
        
        /// Boolean value used to get a recursive tree.
        @OutputParam(key: "recursive")
        public var recursive: Bool?
        
        /// The name of a repository branch or tag or, if not given, the default branch.
        @OutputParam(key: "ref")
        public var ref: String?

        public init(project: InputParams.ProjectID,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
