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

extension APIService.RepositoryFiles {
    
    public class CreateOptions: OutputParamsCollection {
        
        /// Name of the new branch to create. The commit is added to this branch.
        @OutputParam(key: "branch")
        public var branch: String?
        
        /// The commit message.
        @OutputParam(key: "commit_message")
        public var commitMessage: String?
        
        /// The file’s content.
        @OutputParam(key: "content")
        public var content: String?
        
        /// URL-encoded full path to new file. For example: lib%2Fclass%2Erb.
        @OutputParam(key: "file_path")
        public var filePath: String?
        
        /// The ID or URL-encoded path of the project owned by the authenticated user.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The commit author’s email address.
        @OutputParam(key: "author_email")
        public var authorEmail: String?
        
        /// The commit author’s name.
        @OutputParam(key: "author_name")
        public var authorName: String?
        
        /// Change encoding to `base64`. Default is `text`.
        @OutputParam(key: "encoding")
        public var encoding: String?
        
        /// Enables or disables the execute flag on the file. Can be true or false.
        @OutputParam(key: "execute_filemode")
        public var fileMode: String?
        
        /// Name of the base branch to create the new branch from.
        @OutputParam(key: "start_branch")
        public var startBranch: String?

        public init(branch: String,
                    commit: String,
                    content: String,
                    filePath: String,
                    project: InputParams.Project,
                    _ configure: ((CreateOptions) -> Void)?) {
            super.init()
            self.project = project
            self.branch = branch
            self.content = content
            self.filePath = filePath
            configure?(self)
        }
        
    }

}

